using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Database;
using Gymify.Services.Helpers;
using Gymify.Services.Interfaces;
using Gymify.Services.Services;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System.Linq;

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

        protected override Task BeforeInsert(UserReward entity, UserRewardInsertRequest request)
        {
            entity.Code = GenerateCode(8);   // generišemo 8 karaktera
            entity.RedeemedAt = DateTime.UtcNow;
            entity.IsUsed = false;

            return base.BeforeInsert(entity, request);
        }

        private string GenerateCode(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return SecureRandomHelper.GenerateString(chars, length);
        }

        public async Task<UserRewardResponse?> RedeemAsync(int userId, int rewardId)
        {
            var reward = await _context.Rewards.FindAsync(rewardId);
            if (reward == null || !reward.IsActive)
                return null;

            var loyalty = await _context.LoyaltyPoints
                .FirstOrDefaultAsync(x => x.UserId == userId);

            if (loyalty == null || loyalty.TotalPoints < reward.RequiredPoints)
                return null;

            loyalty.TotalPoints -= reward.RequiredPoints;

            var userReward = new UserReward
            {
                UserId = userId,
                RewardId = rewardId,
                RedeemedAt = DateTime.UtcNow,
                IsUsed = false
            };

            _context.UserRewards.Add(userReward);
            await _context.SaveChangesAsync();

            return _mapper.Map<UserRewardResponse>(userReward);
        }
    }
}