using System;

namespace Gymify.Model.RequestObjects
{
    public class ReservationUpsertRequest
    {
        public int UserId { get; set; }
        public int TrainingId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
