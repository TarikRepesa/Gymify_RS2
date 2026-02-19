using System;

namespace Gymify.Model.RequestObjects
{
    public class NotificationUpsertRequest
    {
        public int UserId { get; set; }
        public string Title {get; set;}
        public string Content {get; set;}
        public DateTime CreatedAt {get; set;}
    }
}
