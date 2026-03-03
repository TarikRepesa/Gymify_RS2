using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class LoyaltyPointAdjustRequest
    {
        [Required]
        public int UserId { get; set; }

        // koliko poena dodaješ/skidaš (pozitivan broj)
        [Range(1, int.MaxValue, ErrorMessage = "Points mora biti >= 1.")]
        public int Points { get; set; }
    }
}