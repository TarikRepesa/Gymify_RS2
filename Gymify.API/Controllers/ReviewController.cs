using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

// Create: Korisnik
// Delete: Admin, Radnik
// Get: Korisnik, Admin, Radnik

namespace Gymify.API.Controllers
{
    public class ReviewController : BaseCRUDController<ReviewResponse, ReviewSearchObject, ReviewUpsertRequest, ReviewUpsertRequest>
    {
        public ReviewController(IReviewService service) : base(service)
        {
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<PagedResult<ReviewResponse>> Get([FromQuery] ReviewSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<ReviewResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<ReviewResponse?> Update(int id, [FromBody] ReviewUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize(Roles = "Korisnik")]
        public override Task<ReviewResponse> Create([FromBody] ReviewUpsertRequest request)
        {
            return base.Create(request);
        }
    }
}
