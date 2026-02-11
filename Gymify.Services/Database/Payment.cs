using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class Payment
    {
        [Key]
        public int Id {get; set;}

        [ForeignKey(nameof(UserId))]

        public int UserId {get; set;}

        public User User {get; set;}

        [ForeignKey(nameof(MembershipId))]

        public int MembershipId {get; set;}

        public Membership Membership {get; set;}

        public double Amount {get; set;}

        public DateTime PaymentDate {get; set;}
        
    }
}