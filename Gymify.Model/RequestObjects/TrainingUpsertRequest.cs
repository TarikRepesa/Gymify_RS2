using System;

namespace Gymify.Model.RequestObjects
{
    public class TrainingUpsertRequest
    {
        public int UserId { get; set; }
        public string Name { get; set; }
        public string? TrainingImage { get; set;}
        public int MaxAmountOfParticipants { get; set; }
        public int CurrentParticipants { get; set; }
        public int DurationMinutes { get; set; }
        public int IntensityLevel { get; set; } 
        public string Purpose { get; set; } = ""; 
        public DateTime StartDate { get; set; }
    }
}
