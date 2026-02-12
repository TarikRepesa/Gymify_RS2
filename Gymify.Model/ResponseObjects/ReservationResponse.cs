using System;

namespace Gymify.Model.ResponseObjects
{
    public class ReservationResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int TrainingId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
