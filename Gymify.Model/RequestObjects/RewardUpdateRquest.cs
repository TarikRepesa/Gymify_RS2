using System;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class RewardUpdateRequest
    {
        [Required, MaxLength(150)]
        public string Name { get; set; } = "";

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "RequiredPoints mora biti veći od 0.")]
        public int RequiredPoints { get; set; }
        [Required]
        public DateTime ValidFrom { get; set; }

        [Required]
        public DateTime ValidTo { get; set; }

        public string Status {get; set;}
    }
}