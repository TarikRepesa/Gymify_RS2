using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class WorkerTask
    {
        [Key]

        public int Id {get; set;}

        [ForeignKey(nameof(UserId))]

        public int UserId {get; set;}
        
        public User User {get; set;}

        public string Name {get; set;}

        public string Details {get; set;}

        public DateTime CreatedTaskDate {get; set;}

        public DateTime ExparationTaskDate {get; set;}

        public bool IsFinished {get; set;}
    
    }
}