using System;

namespace Gymify.Model.ResponseObjects
{
    public class ReviewResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Message { get; set; }
        public int StarNumber { get; set; }
    }
}
