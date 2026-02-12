using System;

namespace Gymify.Model.ResponseObjects
{
    public class LoyaltyPointHistoryResponse
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public string Status { get; set; } = string.Empty;

        public int AmountPointsParticipation { get; set; }

        public DateTime CreatedAt { get; set; }
    }
}
