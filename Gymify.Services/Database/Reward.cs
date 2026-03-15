using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Services.Database
{
    public class Reward
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(150)]
        public string Name { get; set; }

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public int RequiredPoints { get; set; }

        public bool IsActive { get; set; } = true;

        // Navigacija
        public ICollection<UserReward> UserRewards { get; set; } = new List<UserReward>();
    }
}