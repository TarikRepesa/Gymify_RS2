using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IReservationService : ICRUDService<ReservationResponse, BaseSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
    }
}
