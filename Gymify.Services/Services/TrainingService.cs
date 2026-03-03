using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System.Runtime.InteropServices;

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
    }
}
