using System;

namespace Gymify.Model.RequestObjects
{
    public class WorkerTaskUpsertRequest
    {
        public string Name { get; set; }
        public string Details { get; set; }
        public DateTime CreatedTaskDate { get; set; }
        public DateTime ExparationTaskDate { get; set; }
        public bool IsFinished { get; set; }
    }
}
