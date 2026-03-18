using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Get: Korisnik,Admin,Radnik
//Update: Korisnik,Admin,Radnik
//Delete: Admin,Radnik
//Create: Korisnik,Admin,Radnik

namespace Gymify.API.Controllers
{
    public class MemberController : BaseCRUDController<MemberResponse, MemberSearchObject, MemberInsertRequest, MemberUpdateRequest>
    {
        public MemberController(IMemberService service) : base(service)
        {
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]   
        public override Task<PagedResult<MemberResponse>> Get([FromQuery] MemberSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]  
        public override Task<MemberResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")] 
        public override Task<MemberResponse> Create([FromBody] MemberInsertRequest request)
        {
            return base.Create(request);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")] 
        public override Task<MemberResponse?> Update(int id, [FromBody] MemberUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin,Radnik")] 
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }

    
}
