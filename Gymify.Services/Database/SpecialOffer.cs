using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Services.Database
{
    public class SpecialOffer
    {
        [Key]

        public int Id {get; set;}

        public string Name {get; set;}

        public string Details {get; set;}

        public int ValueOfLoyaltyPoints {get; set;}
    }
}