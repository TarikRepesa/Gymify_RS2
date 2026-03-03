using System;

namespace Gymify.Model.ResponseObjects
{
    public class UserRewardResponse
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public UserResponse? User { get; set; }

        public int RewardId { get; set; }
        public RewardResponse? Reward { get; set; }

        public DateTime RedeemedAt { get; set; }
        public bool IsUsed { get; set; }

        public String? Code {get; set;}
    }
}