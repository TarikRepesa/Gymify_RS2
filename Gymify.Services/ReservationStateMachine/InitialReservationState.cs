using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Services.Database;
using MapsterMapper;

namespace Gymify.Services.ReservationStateMachine
{
    public class InitialReservationState : BaseReservationState
    {
        public InitialReservationState(
            IServiceProvider serviceProvider,
            GymifyDbContext context,
            IMapper mapper
        ) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest request)
        {
            var entity = _mapper.Map<Reservation>(request);

            entity.Status = "Confirmed";
            entity.CancelledAt = null;
            entity.CancelReason = null;

            _context.Reservations.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationResponse>(entity);
        }

        public override List<string> AllowedActions(int id)
        {
            return new List<string>
            {
                nameof(CreateAsync)
            };
        }
    }
}