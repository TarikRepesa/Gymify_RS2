using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Gymify.Services.Database
{
    public class Training
    {
       [Key]

       public int Id {get; set;}

       [ForeignKey(nameof(UserId))]

       public int UserId {get; set;}  

       public User User {get; set;}

       public string Name {get; set;}

       public int MaxAmountOfParticipants {get; set;}

       public int CurrentParticipants {get; set;}
       
       // Posto start date ima i podatke u vremenu, tu cu izvlaciti vrijeme u klk trening pocinje
       //Imat cu posebne 2 metode u helperu koje ce ovo regulisati 
       public DateTime StartDate {get; set;}


    }
}