using Gymify.API.Controllers;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Get: Korisnik,Admin,Radnik
//Create: Korisnik
//Update: Admin,Radnik
//Delete: Admin,Radnik


namespace Gymify.API.Controllers
{
    public class UserRewardController
        : BaseCRUDController<UserRewardResponse, UserRewardSearchObject, UserRewardInsertRequest, UserRewardUpdateRequest>
    {
        public UserRewardController(IUserRewardService service)
            : base(service) { }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<PagedResult<UserRewardResponse>> Get([FromQuery] UserRewardSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<UserRewardResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<UserRewardResponse?> Update(int id, [FromBody] UserRewardUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Korisnik")]
        public override Task<UserRewardResponse> Create([FromBody] UserRewardInsertRequest request)
        {
            return base.Create(request);
        }
    }
}