using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Create: Korisnik
//Delete: Korisnik,Admin,Radnik
//Get: Korisnik,Admin,Radnik

namespace Gymify.API.Controllers
{
    public class ReservationController : BaseCRUDController<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        IReservationService _service;
        public ReservationController(IReservationService service) : base(service)
        {
            _service = service;
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        [HttpGet("exists")]
        public async Task<bool> Exists([FromQuery] ReservationCheckRequets req)
        {
            return await _service.ExistsAsync(req);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<PagedResult<ReservationResponse>> Get([FromQuery] ReservationSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<ReservationResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize(Roles = "Korisnik")]
        public override Task<ReservationResponse?> Update(int id, [FromBody] ReservationUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Korisnik")]
        public override Task<ReservationResponse> Create([FromBody] ReservationUpsertRequest request)
        {
            return base.Create(request);
        }
    }
}
