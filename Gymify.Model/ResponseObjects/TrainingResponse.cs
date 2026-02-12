using System;

namespace Gymify.Model.ResponseObjects
{
    public class TrainingResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; }
        public int MaxAmountOfParticipants { get; set; }
        public int CurrentParticipants { get; set; }
        public DateTime StartDate { get; set; }
    }
}
