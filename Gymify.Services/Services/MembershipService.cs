using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Gymify.Services.Exceptions;

namespace Gymify.Services.Services
{
    public class MembershipService
        : BaseCRUDService<
            MembershipResponse,
            BaseSearchObject,
            Membership,
            MembershipUpsertRequest,
            MembershipUpsertRequest>,
          IMembershipService
    {
        public MembershipService(GymifyDbContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        protected override IQueryable<Membership> ApplyFilter(
            IQueryable<Membership> query,
            BaseSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x => x.Name.ToLower().Contains(search.FTS.ToLower()));
            }
            return base.ApplyFilter(query, search);
        }

        protected override async Task BeforeInsert(
            Membership entity,
            MembershipUpsertRequest request)
        {
            entity.CreatedAt = DateTime.Now;

            await base.BeforeInsert(entity, request);
        }

        protected override async Task BeforeDelete(Membership entity)
        {
            var today = DateTime.UtcNow.Date;

            var hasActiveMembers = await _context.Members
                .AnyAsync(x =>
                    x.MembershipId == entity.Id &&
                    x.ExpirationDate.Date >= today
                );

            if (hasActiveMembers)
            {
                throw new UserException(
                    "Članarina se ne može obrisati jer postoje aktivni korisnici koji je koriste."
                );
            }
            await base.BeforeDelete(entity);
        }
    }
}