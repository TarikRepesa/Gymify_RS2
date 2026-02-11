using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class Review
    {
       [Key]

       public int Id {get; set;}

       [ForeignKey(nameof(UserId))]

        public int UserId {get; set;}

        public User User {get; set;}

        public string Message {get; set;}

        public int StarNumber {get; set;}

    }
}