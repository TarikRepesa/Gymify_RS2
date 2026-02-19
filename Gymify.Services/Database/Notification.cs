using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class Notification
    {
       [Key]

       public int Id {get; set;}

       [ForeignKey(nameof(UserId))]

        public int UserId {get; set;}

        public User User {get; set;}

        public string Title {get; set;}

        public string Content {get; set;}

        public DateTime CreatedAt {get; set;}

    }
}