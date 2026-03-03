using Gymify.API.Controllers;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;

namespace Gymify.API.Controllers
{
    public class UserRewardController
        : BaseCRUDController<UserRewardResponse, UserRewardSearchObject, UserRewardInsertRequest, UserRewardUpdateRequest>
    {
        public UserRewardController(IUserRewardService service)
            : base(service) { }
    }
}