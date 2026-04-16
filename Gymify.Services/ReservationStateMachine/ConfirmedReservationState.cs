using Gymify.Model.ResponseObjects;
using Gymify.Services.Database;
using Gymify.Services.Exceptions;
using MapsterMapper;

namespace Gymify.Services.ReservationStateMachine
{
    public class ConfirmedReservationState : BaseReservationState
    {
        public ConfirmedReservationState(
            IServiceProvider serviceProvider,
            GymifyDbContext context,
            IMapper mapper
        ) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<ReservationResponse> ToCancelledAsync(int id, string reason)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                throw new UserException("Rezervacija nije pronađena.");

            entity.Status = "Cancelled";
            entity.CancelledAt = DateTime.Now;
            entity.CancelReason = reason;

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }

        public override List<string> AllowedActions(int id)
        {
            return new List<string>
            {
                nameof(ToCancelledAsync)
            };
        }
    }
}