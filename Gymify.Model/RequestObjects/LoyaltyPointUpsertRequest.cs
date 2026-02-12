using System;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class LoyaltyPointUpsertRequest
    {
        [Required]
        public int UserId { get; set; }

        [Required]
        public int TotalPoints { get; set; }
    }
}
