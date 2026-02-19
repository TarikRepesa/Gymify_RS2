using System;

namespace Gymify.Model.RequestObjects
{
    public class NotificationUpsertRequest
    {
        public int UserId { get; set; }
        public string Message {get; set;}
        public DateTime CreatedAt {get; set;}
    }
}
