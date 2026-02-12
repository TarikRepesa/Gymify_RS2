using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class MembershipService : BaseCRUDService<MembershipResponse, BaseSearchObject, Membership, MembershipUpsertRequest, MembershipUpsertRequest>, IMembershipService
    {
        public MembershipService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
