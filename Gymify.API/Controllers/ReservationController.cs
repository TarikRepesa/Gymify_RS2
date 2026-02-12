using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class ReservationController : BaseCRUDController<ReservationResponse, BaseSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        public ReservationController(IReservationService service) : base(service)
        {
        }
    }
}
