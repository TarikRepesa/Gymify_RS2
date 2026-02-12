using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class LoyaltyPointService : BaseCRUDService<LoyaltyPointResponse, BaseSearchObject, LoyaltyPoint, LoyaltyPointUpsertRequest, LoyaltyPointUpsertRequest>, ILoyaltyPointService
    {
        public LoyaltyPointService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
