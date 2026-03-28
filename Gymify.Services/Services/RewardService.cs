using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Database;
using Gymify.Services.Exceptions;
using Gymify.Services.Interfaces;
using Gymify.Services.Services;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Implementations
{
    public class RewardService
        : BaseCRUDService<
            RewardResponse,
            RewardSearchObject,
            Reward,
            RewardInsertRequest,
            RewardUpdateRequest>,
          IRewardService
    {
        private readonly GymifyDbContext _context;

        public RewardService(GymifyDbContext context, IMapper mapper)
            : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Reward> ApplyFilter(
            IQueryable<Reward> query,
            RewardSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                var s = search.Name.ToLower();
                query = query.Where(x => x.Name.ToLower().Contains(s));
            }

            if (!string.IsNullOrWhiteSpace(search.Status))
            {
                var status = search.Status.Trim();
                query = query.Where(x => x.Status == status);
            }

            return base.ApplyFilter(query, search);
        }

        protected override async Task BeforeInsert(Reward entity, RewardInsertRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
                throw new UserException("Naziv nagrade je obavezan.");

            if (request.RequiredPoints <= 0)
                throw new UserException("Potrebni poeni moraju biti veći od 0.");

            if (request.ValidTo < request.ValidFrom)
                throw new UserException("Datum 'Vrijedi do' ne može biti prije datuma 'Vrijedi od'.");

            entity.Status = ResolveRewardStatusForNormalFlow(request.ValidFrom, request.ValidTo);
            entity.IsLockedForEdit = false;
            entity.CanDelete = true;
            entity.RedemptionCount = 0;

            await base.BeforeInsert(entity, request);
        }

        protected override async Task BeforeUpdate(Reward entity, RewardUpdateRequest request)
        {
            var existing = await _context.Rewards
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.Id == entity.Id);

            if (existing == null)
                throw new NotFoundException("Nagrada nije pronađena.");

            if (string.IsNullOrWhiteSpace(request.Name))
                throw new UserException("Naziv nagrade je obavezan.");

            if (request.RequiredPoints <= 0)
                throw new UserException("Potrebni poeni moraju biti veći od 0.");

            if (request.ValidTo < request.ValidFrom)
                throw new UserException("Datum 'Vrijedi do' ne može biti prije datuma 'Vrijedi od'.");

            var hasAnyRedemption = await _context.UserRewards
                .AnyAsync(x => x.RewardId == entity.Id);

            if (hasAnyRedemption)
            {
                if (!string.Equals(existing.Name, request.Name, StringComparison.Ordinal))
                    throw new UserException("Naziv nagrade se ne može mijenjati nakon što je nagrada iskorištena.");

                if (!string.Equals(existing.Description ?? "", request.Description ?? "", StringComparison.Ordinal))
                    throw new UserException("Opis nagrade se ne može mijenjati nakon što je nagrada iskorištena.");

                if (existing.RequiredPoints != request.RequiredPoints)
                    throw new UserException("Potrebni poeni se ne mogu mijenjati nakon što je nagrada iskorištena.");

                if (existing.ValidFrom != request.ValidFrom)
                    throw new UserException("Datum 'Vrijedi od' se ne može mijenjati nakon što je nagrada iskorištena.");
            }

            entity.Status = ResolveRewardStatusForUpdate(
                requestedStatus: request.Status,
                validFrom: request.ValidFrom,
                validTo: request.ValidTo
            );

            entity.IsLockedForEdit = hasAnyRedemption;
            entity.CanDelete = !hasAnyRedemption;
            entity.RedemptionCount = await _context.UserRewards
                .CountAsync(x => x.RewardId == entity.Id);

            await base.BeforeUpdate(entity, request);
        }

        protected override async Task BeforeDelete(Reward entity)
        {
            var existing = await _context.Rewards
                .FirstOrDefaultAsync(x => x.Id == entity.Id);

            if (existing == null)
                throw new NotFoundException("Nagrada nije pronađena.");

            var now = DateTime.UtcNow;

            var hasBlockingCodes = await _context.UserRewards
                .AnyAsync(x =>
                    x.RewardId == entity.Id &&
                    x.Status == "Active" &&
                    existing.ValidTo >= now);

            if (hasBlockingCodes)
            {
                throw new InvalidOperationException(
                    "Nagrada se ne može trajno obrisati dok postoje korisnici sa aktivnim kodovima koji još nisu iskorišteni ili nisu istekli.");
            }

            await base.BeforeDelete(entity);
        }

        private static string ResolveRewardStatusForNormalFlow(DateTime validFrom, DateTime validTo)
        {
            var now = DateTime.UtcNow;

            if (validTo < now)
                return "Expired";

            if (validFrom > now)
                return "Planned";

            return "Active";
        }

        private static string ResolveRewardStatusForUpdate(
            string? requestedStatus,
            DateTime validFrom,
            DateTime validTo)
        {
            var now = DateTime.UtcNow;
            var normalizedStatus = requestedStatus?.Trim();

            if (normalizedStatus == "SoftDeleted")
                return "SoftDeleted";

            if (normalizedStatus == "Inactive")
            {
                if (validTo < now)
                    return "Expired";

                if (validFrom > now)
                    return "Planned";

                return "Inactive";
            }

            if (validTo < now)
                return "Expired";

            if (validFrom > now)
                return "Planned";

            return "Active";
        }
    }
}