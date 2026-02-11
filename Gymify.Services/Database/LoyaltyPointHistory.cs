using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class LoyaltyPointHistory
    {
       [Key]

       public int Id {get; set;}

       [ForeignKey(nameof(UserId))]

        public int UserId {get; set;}

        public User User {get; set;}

        // dodavanje bodova, palacanje bodovima itd..
        public string Status {get; set;}

        // npr. ako je status "dodavanje bodova" ovdje pise 10, to je da se 10 bodova dodalo totalu
        public int AmountPointsParticipation {get; set;}

        public DateTime CreatedAt {get; set;}

    }
}