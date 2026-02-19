using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Services
{
    public class MemberService : BaseCRUDService<MemberResponse, MemberSearchObject, Member, MemberUpsertRequest, MemberUpsertRequest>, IMemberService
    {
        public MemberService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Member> ApplyFilter(IQueryable<Member> query, MemberSearchObject search)
        {
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    (x.User.FirstName + " " + x.User.LastName).ToLower().Contains(search.FTS.ToLower())
                    || x.User.Email.ToLower().Contains(search.FTS.ToLower())
                );
            }
            return base.ApplyFilter(query, search);
        }

        protected override IQueryable<Member> AddInclude(IQueryable<Member> query, MemberSearchObject search)
        {
            if (search.IncludeUser.HasValue)
            {
                query = query.Include(x => x.User);
            }

            if (search.IncludeMembership.HasValue)
            {
                query = query.Include(x => x.Membership);
            }
            return base.AddInclude(query, search);
        }

    }
}
