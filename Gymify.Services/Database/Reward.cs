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
    public string Name { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? Description { get; set; }

    [Required]
    public int RequiredPoints { get; set; }

    public DateTime ValidFrom { get; set; }
    public DateTime ValidTo { get; set; }

    [Required]
    [MaxLength(30)]
    public string Status { get; set; } = "Planned";

    public bool IsLockedForEdit { get; set; }
    public bool CanDelete { get; set; }
    public int RedemptionCount { get; set; }

    public ICollection<UserReward> UserRewards { get; set; } = new List<UserReward>();
}
}