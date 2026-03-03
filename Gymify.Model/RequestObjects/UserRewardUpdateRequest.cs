using System;

namespace Gymify.Model.RequestObjects
{
    public class UserRewardUpdateRequest
    {
        public bool IsUsed { get; set; }
        public DateTime? RedeemedAt { get; set; } 
    }
}