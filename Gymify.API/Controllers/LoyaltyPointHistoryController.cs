using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class LoyaltyPointHistoryController : BaseCRUDController<LoyaltyPointHistoryResponse, BaseSearchObject, LoyaltyPointHistoryUpsertRequest, LoyaltyPointHistoryUpsertRequest>
    {
        public LoyaltyPointHistoryController(ILoyaltyPointHistoryService service) : base(service)
        {
        }
    }
}
