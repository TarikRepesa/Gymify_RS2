using System;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class RewardInsertRequest
    {
        [Required, MaxLength(150)]
        public string Name { get; set; } = "";

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "RequiredPoints mora biti veći od 0.")]
        public int RequiredPoints { get; set; }

        public bool IsActive { get; set; } = true;

        [Required]
        public DateTime ValidFrom { get; set; }

        [Required]
        public DateTime ValidTo { get; set; }
        public bool IsDeleted { get; set; } = false;
    }
}