using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Gymify.Services.Exceptions;
using Gymify.Services.ReservationStateMachine;

namespace Gymify.Services.Services
{
    public class ReservationService : BaseCRUDService<ReservationResponse, ReservationSearchObject, Reservation, ReservationUpsertRequest, ReservationUpsertRequest>, IReservationService
    {
        private readonly BaseReservationState _baseReservationState;

        public ReservationService(
            GymifyDbContext context,
            IMapper mapper,
            BaseReservationState baseReservationState
        ) : base(context, mapper)
        {
            _baseReservationState = baseReservationState;
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

        public async override Task<ReservationResponse> CreateAsync(ReservationUpsertRequest request)
        {
            var entity = _mapper.Map<Reservation>(request);

            await BeforeInsert(entity, request);

            var state = _baseReservationState.GetState(nameof(InitialReservationState));
            return await state.CreateAsync(request);
        }

        protected override async Task BeforeInsert(Reservation entity, ReservationUpsertRequest request)
        {
            var member = await _context.Members
                .Where(x => x.UserId == request.UserId)
                .OrderByDescending(x => x.ExpirationDate)
                .FirstOrDefaultAsync();

            if (member == null)
            {
                throw new UserException("Nemate aktivnu članarinu.");
            }

            if (member.ExpirationDate <= DateTime.Now)
            {
                throw new UserException("Vaša članarina je istekla.");
            }

            var alreadyExists = await _context.Reservations
                .AnyAsync(x => x.UserId == request.UserId && x.TrainingId == request.TrainingId);

            if (alreadyExists)
            {
                throw new UserException("Korisnik je već rezervisao ovaj trening.");
            }

            await base.BeforeInsert(entity, request);
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

        public async Task<ReservationResponse> CancelAsync(int id, string reason)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                throw new UserException("Rezervacija nije pronađena.");

            var state = GetStateForStatus(entity.Status);
            return await state.ToCancelledAsync(id, reason);
        }

        public async Task<List<string>> GetAllowedActions(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                throw new UserException("Rezervacija nije pronađena.");

            var state = GetStateForStatus(entity.Status);
            return state.AllowedActions(id);
        }

        private BaseReservationState GetStateForStatus(string? status)
        {
            return status switch
            {
                null => _baseReservationState.GetState(nameof(InitialReservationState)),
                "Confirmed" => _baseReservationState.GetState(nameof(ConfirmedReservationState)),
                "Cancelled" => _baseReservationState.GetState(nameof(CancelledReservationState)),
                _ => throw new Exception($"Status {status} nije podržan.")
            };
        }
    }
}