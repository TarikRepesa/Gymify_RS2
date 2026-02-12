using System;

namespace Gymify.Model.RequestObjects
{
    public class TrainingUpsertRequest
    {
        public int UserId { get; set; }
        public string Name { get; set; }
        public int MaxAmountOfParticipants { get; set; }
        public int CurrentParticipants { get; set; }
        public DateTime StartDate { get; set; }
    }
}
