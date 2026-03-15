using System;

namespace Gymify.Model.RequestObjects
{
    public class WorkerTaskUpsertRequest
    {
        public int UserId {get; set;}
        public string Name { get; set; }
        public string Details { get; set; }
        public DateTime CreatedTaskDate { get; set; }
        public DateTime "ExpirationTaskDate { get; set; }
        public bool IsFinished { get; set; }
    }
}
