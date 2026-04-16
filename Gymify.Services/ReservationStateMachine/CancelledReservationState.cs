using Gymify.Services.Database;
using MapsterMapper;

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

        public override List<string> AllowedActions(int id)
        {
            return new List<string>();
        }
    }
}