using System;
using System.Diagnostics.Contracts;

namespace Gymify.Model.ResponseObjects
{
    public class ReviewResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public UserResponse User {get; set;}
        public string Message { get; set; }
        public int StarNumber { get; set; }
    }
}
