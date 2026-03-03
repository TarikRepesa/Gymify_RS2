using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class UserReward
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(UserId))]
        public int UserId { get; set; }

        public User? User { get; set; }

        [ForeignKey(nameof(RewardId))]
        public int RewardId { get; set; }

        public Reward? Reward { get; set; }

        public String? Code {get; set;}

        public DateTime RedeemedAt { get; set; } = DateTime.UtcNow;

        public bool IsUsed { get; set; } = false;
    }
}