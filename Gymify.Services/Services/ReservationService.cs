using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Gymify.Services.Exceptions;

namespace Gymify.Services.Services
{
    public class ReservationService : BaseCRUDService<ReservationResponse, ReservationSearchObject, Reservation, ReservationUpsertRequest, ReservationUpsertRequest>, IReservationService
    {
        public ReservationService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Reservation> ApplyFilter(
     IQueryable<Reservation> query,
     ReservationSearchObject search)
        {
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }

            if (!string.IsNullOrWhiteSpace(search.Status))
            {
                var status = search.Status.Trim().ToLower();

                query = query.Where(x => x.Status.ToLower() == status);
            }

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                var fts = search.FTS.Trim().ToLower();

                query = query.Where(r =>
                    (r.Training != null &&
                     r.Training.Name != null &&
                     r.Training.Name.ToLower().Contains(fts))

                    ||

                    (r.Training != null &&
                     r.Training.User != null &&
                     (
                        (r.Training.User.FirstName != null &&
                         r.Training.User.FirstName.ToLower().Contains(fts))

                        || (r.Training.User.LastName != null &&
                            r.Training.User.LastName.ToLower().Contains(fts))

                        || ((r.Training.User.FirstName ?? "") + " " + (r.Training.User.LastName ?? ""))
                            .ToLower()
                            .Contains(fts)

                        || ((r.Training.User.LastName ?? "") + " " + (r.Training.User.FirstName ?? ""))
                            .ToLower()
                            .Contains(fts)
                     ))
                );
            }

            return base.ApplyFilter(query, search);
        }

        protected override async Task BeforeInsert(Reservation entity, ReservationUpsertRequest request)
        {
            await base.BeforeInsert(entity, request);

            var alreadyExists = await _context.Reservations
                .AnyAsync(x => x.UserId == request.UserId && x.TrainingId == request.TrainingId);

            if (alreadyExists)
            {
                throw new BusinessException("Korisnik je već rezervisao ovaj trening.");
            }
        }

        protected override IQueryable<Reservation> AddInclude(IQueryable<Reservation> query, ReservationSearchObject search)
        {
            if (search.IncludeUser.HasValue)
            {
                query = query.Include(x => x.User);
            }

            if (search.IncludeTraining.HasValue)
            {
                query = query.Include(x => x.Training).ThenInclude(x => x.User);
            }
            return base.AddInclude(query, search);
        }

        public async Task<bool> ExistsAsync(ReservationCheckRequets req)
        {
            return await _context.Reservations
                .AnyAsync(x => x.UserId == req.UserId && x.TrainingId == req.TrainingId);
        }
    }
}
