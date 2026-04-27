using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Services.Database;
using Gymify.Services.Exceptions;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.ReservationStateMachine
{
    public class CancelledReservationState : BaseReservationState
    {
        public CancelledReservationState(
            IServiceProvider serviceProvider,
            GymifyDbContext context,
            IMapper mapper
        ) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<bool> DeleteAsync(int id)
        {
            var entity = await _context.Reservations
                .FirstOrDefaultAsync(r => r.Id == id);

            _context.Reservations.Remove(entity);

            await _context.SaveChangesAsync();
            return true;
        }

        public override List<string> AllowedActions(int id)
        {
            return new List<string>
            {
                nameof(DeleteAsync)
            };
        }
    }
}