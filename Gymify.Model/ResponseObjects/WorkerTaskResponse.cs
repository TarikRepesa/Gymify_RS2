using System;

namespace Gymify.Model.ResponseObjects
{
    public class WorkerTaskResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Details { get; set; }
        public DateTime CreatedTaskDate { get; set; }
        public DateTime ExparationTaskDate { get; set; }
        public bool IsFinished { get; set; }
    }
}
