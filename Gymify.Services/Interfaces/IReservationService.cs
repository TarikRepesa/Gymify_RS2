using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IReservationService : ICRUDService<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        Task<bool> ExistsAsync(ReservationCheckRequets req);
        public Task<ReservationResponse> CancelAsync(int id, string reason);
        Task<List<string>> GetAllowedActions(int id);
    }
}