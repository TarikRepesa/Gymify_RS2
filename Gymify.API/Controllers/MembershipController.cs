using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Get: Korisnik,Admin,Radnik
//Update: Admin,Radnik
//Delete: Admin,Radnik
//Create: Admin,Radnik

namespace Gymify.API.Controllers
{
    public class MembershipController : BaseCRUDController<MembershipResponse, BaseSearchObject, MembershipUpsertRequest, MembershipUpsertRequest>
    {
        public MembershipController(IMembershipService service) : base(service)
        {
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]   
        public override Task<PagedResult<MembershipResponse>> Get([FromQuery] BaseSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<MembershipResponse?> GetById(int id)
        {
            return base.GetById(id);
        }
        
        [Authorize(Roles = "Admin,Radnik")]
        public override Task<MembershipResponse?> Update(int id, [FromBody] MembershipUpsertRequest request)
        {
            return base.Update(id, request);
        }
        
        [Authorize(Roles = "Admin,Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<MembershipResponse> Create([FromBody] MembershipUpsertRequest request)
        {
            return base.Create(request);
        }
    }
}
