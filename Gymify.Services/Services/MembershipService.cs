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

        protected override IQueryable<Membership> ApplyFilter(IQueryable<Membership> query, BaseSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x => x.Name.ToLower().Contains(search.FTS.ToLower()));
            }
            return base.ApplyFilter(query, search);
        }
    }
}
