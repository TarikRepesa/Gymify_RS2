using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class LoyaltyPointHistoryService : BaseCRUDService<LoyaltyPointHistoryResponse, BaseSearchObject, LoyaltyPointHistory, LoyaltyPointHistoryUpsertRequest, LoyaltyPointHistoryUpsertRequest>, ILoyaltyPointHistoryService
    {
        public LoyaltyPointHistoryService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
