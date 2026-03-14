using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System.Runtime.InteropServices;
using Gymify.Services.Recommender;

namespace Gymify.Services.Services
{
    public class TrainingService : BaseCRUDService<TrainingResponse, TrainingSearchObject, Training, TrainingUpsertRequest, TrainingUpsertRequest>, ITrainingService
    {
        public TrainingService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Training> ApplyFilter(IQueryable<Training> query, TrainingSearchObject search)
        {
            var today = DateTime.Today;
            query = query.Where(x => x.StartDate.Date >= today);
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x => x.Name.ToLower().Contains(search.FTS));
            }

            if (search.StartDate.HasValue)
            {
                query = query.Where(x =>
                    x.StartDate.Date == search.StartDate.Value.Date);
            }
            return base.ApplyFilter(query, search);
        }

        protected override IQueryable<Training> AddInclude(IQueryable<Training> query, TrainingSearchObject search)
        {
            if (search.IncludeUser.HasValue)
            {
                query = query.Include(x => x.User);
            }
            return base.AddInclude(query, search);
        }

        public async Task Up(int trainingId)
        {
            var training = await _context.Trainings
                .FirstOrDefaultAsync(x => x.Id == trainingId);

            if (training == null)
                throw new SEHException("Trening ne postoji.");

            var current = training.CurrentParticipants;
            var max = training.MaxAmountOfParticipants;

            if (current >= max)
                throw new Exception("Trening je popunjen.");

            training.CurrentParticipants = current + 1;

            await _context.SaveChangesAsync();
        }

        public async Task Down(int trainingId)
        {
            var training = await _context.Trainings
                .FirstOrDefaultAsync(x => x.Id == trainingId);

            if (training == null)
                throw new Exception("Trening ne postoji.");

            var current = training.CurrentParticipants;
            training.CurrentParticipants = Math.Max(0, current - 1);

            await _context.SaveChangesAsync();
        }

        public async Task<List<TrainingResponse>> GetRecommended(int userId, int take = 3)
        {
            var reservedTrainingIds = await _context.Reservations
                .Where(x => x.UserId == userId)
                .Select(x => x.TrainingId)
                .Distinct()
                .ToListAsync();

            var reservedTrainings = await _context.Trainings
                .Where(x => reservedTrainingIds.Contains(x.Id))
                .ToListAsync();

            // Ako korisnik nema rezervacija -> fallback
            if (!reservedTrainings.Any())
            {
                var popular = await _context.Trainings
                    .Include(x => x.User)
                    .OrderByDescending(x => x.ParicipatedOfAllTime)
                    .ThenByDescending(x => x.CurrentParticipants)
                    .Take(take)
                    .ToListAsync();

                return _mapper.Map<List<TrainingResponse>>(popular);
            }

            var userProfile = BuildUserProfile(reservedTrainings);

            var candidates = await _context.Trainings
                .Include(x => x.User)
                .Where(x => !reservedTrainingIds.Contains(x.Id))
                .ToListAsync();

            var recommended = candidates
                .Select(t => new
                {
                    Training = t,
                    Distance = CalculateDistance(BuildVector(t), userProfile)
                })
                .OrderBy(x => x.Distance)
                .Take(take)
                .Select(x => x.Training)
                .ToList();

            return _mapper.Map<List<TrainingResponse>>(recommended);
        }

        private TrainingFeatureVector BuildUserProfile(List<Training> reservedTrainings)
        {
            var vectors = reservedTrainings.Select(BuildVector).ToList();

            return new TrainingFeatureVector
            {
                Morning = vectors.Average(x => x.Morning),
                Afternoon = vectors.Average(x => x.Afternoon),
                Evening = vectors.Average(x => x.Evening),

                DurationMinutes = vectors.Average(x => x.DurationMinutes),
                IntensityLevel = vectors.Average(x => x.IntensityLevel),

                Strength = vectors.Average(x => x.Strength),
                WeightLoss = vectors.Average(x => x.WeightLoss),
                Cardio = vectors.Average(x => x.Cardio),
                MartialArts = vectors.Average(x => x.MartialArts),
                Flexibility = vectors.Average(x => x.Flexibility),
            };
        }

        private TrainingFeatureVector BuildVector(Training t)
        {
            var partOfDay = GetPartOfDay(t.StartDate);
            var purpose = (t.Purpose ?? string.Empty).Trim().ToLower();

            return new TrainingFeatureVector
            {
                Morning = partOfDay == "morning" ? 1 : 0,
                Afternoon = partOfDay == "afternoon" ? 1 : 0,
                Evening = partOfDay == "evening" ? 1 : 0,

                DurationMinutes = t.DurationMinutes,
                IntensityLevel = t.IntensityLevel,

                Strength = purpose == "strength" ? 1 : 0,
                WeightLoss = purpose == "weightloss" ? 1 : 0,
                Cardio = purpose == "cardio" ? 1 : 0,
                MartialArts = purpose == "martialarts" ? 1 : 0,
                Flexibility = purpose == "flexibility" ? 1 : 0,
            };
        }

        private string GetPartOfDay(DateTime startDate)
        {
            var hour = startDate.Hour;

            if (hour < 12)
                return "morning";

            if (hour < 17)
                return "afternoon";

            return "evening";
        }

        private double CalculateDistance(TrainingFeatureVector a, TrainingFeatureVector b)
        {
            var valuesA = new double[]
            {
                a.Morning,
                a.Afternoon,
                a.Evening,
                a.DurationMinutes,
                a.IntensityLevel,
                a.Strength,
                a.WeightLoss,
                a.Cardio,
                a.MartialArts,
                a.Flexibility
            };

            var valuesB = new double[]
            {
                b.Morning,
                b.Afternoon,
                b.Evening,
                b.DurationMinutes,
                b.IntensityLevel,
                b.Strength,
                b.WeightLoss,
                b.Cardio,
                b.MartialArts,
                b.Flexibility
            };

            double sum = 0;

            for (int i = 0; i < valuesA.Length; i++)
            {
                sum += Math.Pow(valuesA[i] - valuesB[i], 2);
            }

            return Math.Sqrt(sum);
        }
    }
}
