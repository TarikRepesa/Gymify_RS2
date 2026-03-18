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

        public int MonthlyPrice {get; set;}

        public int YearPrice {get; set;}
        public DateTime CreatedAt {get; set;}
    }
}