using System;

namespace Gymify.Model.SearchObjects
{
    public class UserRewardSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? RewardId { get; set; }
        public bool? IsUsed { get; set; }
        public string? Status {get; set;}
        public DateTime? FromRedeemedAt { get; set; }
        public DateTime? ToRedeemedAt { get; set; }
        public string? Code { get; set; }
    }
}