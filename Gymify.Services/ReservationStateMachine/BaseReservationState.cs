using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Services.Database;
using Gymify.Services.Exceptions;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace Gymify.Services.ReservationStateMachine
{
    public class BaseReservationState
    {
        protected readonly IServiceProvider _serviceProvider;
        protected readonly GymifyDbContext _context;
        protected readonly IMapper _mapper;

        public BaseReservationState(
            IServiceProvider serviceProvider,
            GymifyDbContext context,
            IMapper mapper)
        {
            _serviceProvider = serviceProvider;
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest request)
        {
            throw new UserException("Akcija nije dozvoljena.");
        }

        public virtual async Task<ReservationResponse> UpdateAsync(int id, ReservationUpsertRequest request)
        {
            throw new UserException("Akcija nije dozvoljena.");
        }

        public virtual async Task<ReservationResponse> ToCancelledAsync(int id, string reason)
        {
            throw new UserException("Prelazak na status 'Cancelled' nije dozvoljen.");
        }

        public virtual List<string> AllowedActions(int id)
        {
            throw new UserException("Metoda nije dozvoljena.");
        }

        public BaseReservationState GetState(string stateName)
        {
            return stateName switch
            {
                nameof(InitialReservationState) => _serviceProvider.GetRequiredService<InitialReservationState>(),
                nameof(ConfirmedReservationState) => _serviceProvider.GetRequiredService<ConfirmedReservationState>(),
                nameof(CancelledReservationState) => _serviceProvider.GetRequiredService<CancelledReservationState>(),
                _ => throw new Exception($"State {stateName} nije definisan.")
            };
        }
    }
}