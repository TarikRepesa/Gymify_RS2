using Gymify.API.Controllers;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Get: Korisnik,Admin,Radnik
//Create: Admin,Radnik
//Update: Admin,Radnik
//Delete: Admin,Radnik


namespace Gymify.API.Controllers
{
    public class RewardController
        : BaseCRUDController<RewardResponse, RewardSearchObject, RewardInsertRequest, RewardUpdateRequest>
    {
        public RewardController(IRewardService service)
            : base(service) { }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<PagedResult<RewardResponse>> Get([FromQuery] RewardSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik")]
        public override Task<RewardResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<RewardResponse?> Update(int id, [FromBody] RewardUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<RewardResponse> Create([FromBody] RewardInsertRequest request)
        {
            return base.Create(request);
        }
    }
}