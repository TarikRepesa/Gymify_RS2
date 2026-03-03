using System;
using Gymify.Model.SearchObjects;

namespace Gymify.Model.SearchObjects
{
    public class UserRewardSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? RewardId { get; set; }
        public bool? IsUsed { get; set; }
        public DateTime? RedeemedFrom { get; set; }
        public DateTime? RedeemedTo { get; set; }
    }
}