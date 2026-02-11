using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class Reservation
    {
        [Key]

        public int Id {get; set;}

        [ForeignKey(nameof(UserId))]

        public int UserId {get; set;}

        public User User {get; set;}

        [ForeignKey(nameof(TrainingId))]

        public int TrainingId {get; set;}

        public Training Training {get; set;}

        public DateTime CreatedAt {get; set;}

    }
}