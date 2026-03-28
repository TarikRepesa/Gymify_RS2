using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Database;
using Gymify.Services.Exceptions;
using Gymify.Services.Helpers;
using Gymify.Services.Interfaces;
using Gymify.Services.Services;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Implementations
{
    public class UserRewardService
        : BaseCRUDService<
            UserRewardResponse,
            UserRewardSearchObject,
            UserReward,
            UserRewardInsertRequest,
            UserRewardUpdateRequest>,
          IUserRewardService
    {
        private readonly GymifyDbContext _context;

        public UserRewardService(GymifyDbContext context, IMapper mapper)
            : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<UserReward> ApplyFilter(
            IQueryable<UserReward> query,
            UserRewardSearchObject search)
        {
            query = query
                .Include(x => x.User)
                .Include(x => x.Reward);

            if (search.UserId.HasValue)
                query = query.Where(x => x.UserId == search.UserId.Value);

            if (search.RewardId.HasValue)
                query = query.Where(x => x.RewardId == search.RewardId.Value);

            if (!string.IsNullOrWhiteSpace(search.Status))
                query = query.Where(x => x.Status == search.Status);

            if (search.FromRedeemedAt.HasValue)
                query = query.Where(x => x.RedeemedAt >= search.FromRedeemedAt.Value);

            if (search.ToRedeemedAt.HasValue)
                query = query.Where(x => x.RedeemedAt <= search.ToRedeemedAt.Value);

            if (!string.IsNullOrWhiteSpace(search.Code))
                query = query.Where(x => x.Code!.Contains(search.Code));

            return base.ApplyFilter(query, search);
        }

        protected override async Task BeforeInsert(UserReward entity, UserRewardInsertRequest request)
        {
            var reward = await _context.Rewards.FindAsync(request.RewardId);
            if (reward == null)
                throw new NotFoundException("Odabrana nagrada ne postoji.");

            var now = DateTime.UtcNow;
            var resolvedRewardStatus = ResolveRewardStatusForRead(reward);

            if (resolvedRewardStatus == "SoftDeleted")
                throw new InvalidOperationException("Nagrada je privremeno obrisana.");

            if (resolvedRewardStatus == "Inactive")
                throw new InvalidOperationException("Nagrada nije aktivna.");

            if (resolvedRewardStatus == "Planned")
                throw new InvalidOperationException("Nagrada još nije dostupna za preuzimanje.");

            if (resolvedRewardStatus == "Expired")
                throw new InvalidOperationException("Nagrada je istekla.");

            var loyalty = await _context.LoyaltyPoints
                .FirstOrDefaultAsync(x => x.UserId == request.UserId);

            if (loyalty == null)
                throw new UserException("Korisnik nema loyalty bodove.");

            if (loyalty.TotalPoints < reward.RequiredPoints)
                throw new UserException("Korisnik nema dovoljno bodova za ovu nagradu.");

            loyalty.TotalPoints -= reward.RequiredPoints;

            entity.Code = GenerateCode(8);
            entity.RedeemedAt = now;
            entity.Status = "Active";

            reward.RedemptionCount++;
            reward.CanDelete = false;
            reward.IsLockedForEdit = true;

            await base.BeforeInsert(entity, request);
        }

        protected override async Task BeforeUpdate(UserReward entity, UserRewardUpdateRequest request)
        {
            var existing = await _context.UserRewards
                .Include(x => x.Reward)
                .FirstOrDefaultAsync(x => x.Id == entity.Id);

            if (existing == null)
                throw new NotFoundException("Korisnička nagrada nije pronađena.");

            if (string.IsNullOrWhiteSpace(request.Status))
                throw new UserException("Status je obavezan.");

            var newStatus = request.Status.Trim();

            if (newStatus != "Active" && newStatus != "Used" && newStatus != "Expired")
                throw new UserException("Dozvoljeni statusi su: Active, Used, Expired.");

            if (existing.Status == "Used")
                throw new InvalidOperationException("Iskorištena nagrada ne može mijenjati status.");

            if (existing.Status == "Expired")
                throw new InvalidOperationException("Istekla nagrada ne može mijenjati status.");

            if (newStatus == "Active")
                throw new InvalidOperationException("Status se ne može vratiti na Active.");

            var reward = existing.Reward;
            if (reward == null)
                throw new NotFoundException("Nagrada nije pronađena.");

            var now = DateTime.UtcNow;
            var rewardStatus = ResolveRewardStatusForRead(reward);

            if (rewardStatus == "SoftDeleted")
                throw new InvalidOperationException("Povezana nagrada je privremeno obrisana.");

            if (newStatus == "Used")
            {
                if (reward.ValidTo < now)
                    throw new InvalidOperationException("Nagrada je istekla i više se ne može iskoristiti.");
            }

            if (newStatus == "Expired")
            {
                if (reward.ValidTo >= now)
                    throw new InvalidOperationException("Nagrada još nije istekla i ne može dobiti status Expired.");
            }

            entity.Status = newStatus;

            await base.BeforeUpdate(entity, request);
        }

        protected override async Task BeforeDelete(UserReward entity)
        {
            if (entity.Status?.ToLower() == "active")
            {
                throw new ForbiddenException("Aktivan kod se ne može obrisati.");
            }

            await base.BeforeDelete(entity);
        }

        public async Task<UserRewardResponse?> RedeemAsync(int userId, int rewardId)
        {
            var reward = await _context.Rewards.FindAsync(rewardId);
            if (reward == null)
                throw new NotFoundException("Nagrada nije pronađena.");

            var now = DateTime.UtcNow;
            var resolvedRewardStatus = ResolveRewardStatusForRead(reward);

            if (resolvedRewardStatus == "SoftDeleted")
                throw new InvalidOperationException("Nagrada je privremeno obrisana.");

            if (resolvedRewardStatus == "Inactive")
                throw new InvalidOperationException("Nagrada nije aktivna.");

            if (resolvedRewardStatus == "Planned")
                throw new InvalidOperationException("Nagrada još nije dostupna.");

            if (resolvedRewardStatus == "Expired")
                throw new InvalidOperationException("Nagrada je istekla.");

            var loyalty = await _context.LoyaltyPoints
                .FirstOrDefaultAsync(x => x.UserId == userId);

            if (loyalty == null)
                throw new NotFoundException("Loyalty podaci nisu pronađeni.");

            if (loyalty.TotalPoints < reward.RequiredPoints)
                throw new UserException("Nemate dovoljno bodova za preuzimanje ove nagrade.");

            loyalty.TotalPoints -= reward.RequiredPoints;

            var userReward = new UserReward
            {
                UserId = userId,
                RewardId = rewardId,
                RedeemedAt = now,
                Status = "Active",
                Code = GenerateCode(8)
            };

            reward.RedemptionCount++;
            reward.CanDelete = false;
            reward.IsLockedForEdit = true;

            _context.UserRewards.Add(userReward);
            await _context.SaveChangesAsync();

            var inserted = await _context.UserRewards
                .Include(x => x.User)
                .Include(x => x.Reward)
                .FirstOrDefaultAsync(x => x.Id == userReward.Id);

            return _mapper.Map<UserRewardResponse>(inserted);
        }

        private static string ResolveRewardStatusForRead(Reward reward)
        {
            var now = DateTime.UtcNow;

            if (reward.Status == "SoftDeleted")
                return "SoftDeleted";

            if (reward.ValidTo < now)
                return "Expired";

            if (reward.ValidFrom > now)
                return "Planned";

            if (reward.Status == "Inactive")
                return "Inactive";

            return "Active";
        }

        private string GenerateCode(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return SecureRandomHelper.GenerateString(chars, length);
        }
    }
}