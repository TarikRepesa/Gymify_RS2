using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class ReservationController : BaseCRUDController<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        IReservationService _service;
        public ReservationController(IReservationService service) : base(service)
        {
            _service = service;
        }

        [HttpGet("exists")]
        public async Task<bool> Exists([FromQuery] ReservationCheckRequets req)
        {
            return await _service.ExistsAsync(req);
        }
    }
}
