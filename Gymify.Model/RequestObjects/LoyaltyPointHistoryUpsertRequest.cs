using System;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class LoyaltyPointHistoryUpsertRequest
    {
        [Required]
        public int UserId { get; set; }

        [Required]
        public string Status { get; set; } = string.Empty;

        [Required]
        public int AmountPointsParticipation { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
