using System;

namespace Gymify.Model.ResponseObjects
{
    public class NotificationResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public UserResponse User {get; set;}
        public string Message {get; set;}
        public DateTime CreatedAt {get; set;}
    }
}
