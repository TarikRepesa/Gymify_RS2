using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class RewardUpdateRequest
    {
        [Required, MaxLength(150)]
        public string Name { get; set; }

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public int RequiredPoints { get; set; }

        public bool IsActive { get; set; } = true;
    }
}