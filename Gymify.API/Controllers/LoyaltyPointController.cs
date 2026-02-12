using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class LoyaltyPointController : BaseCRUDController<LoyaltyPointResponse, BaseSearchObject, LoyaltyPointUpsertRequest, LoyaltyPointUpsertRequest>
    {
        public LoyaltyPointController(ILoyaltyPointService service) : base(service)
        {
        }
    }
}
