using Gymify.API.Controllers;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;

namespace Gymify.API.Controllers
{
    public class RewardController
        : BaseCRUDController<RewardResponse, RewardSearchObject, RewardInsertRequest, RewardUpdateRequest>
    {
        public RewardController(IRewardService service)
            : base(service) { }
    }
}