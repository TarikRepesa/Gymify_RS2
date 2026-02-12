using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class MemberService : BaseCRUDService<MemberResponse, BaseSearchObject, Member, MemberUpsertRequest, MemberUpsertRequest>, IMemberService
    {
        public MemberService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
