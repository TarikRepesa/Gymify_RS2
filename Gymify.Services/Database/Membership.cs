using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Gymify.Services.Database
{
    public class Membership
    {
        [Key]

        public int Id {get; set;}

        public string Name {get; set;}

        public int DurationInDays {get; set;}

        public string Detaisl {get; set;}
    }
}