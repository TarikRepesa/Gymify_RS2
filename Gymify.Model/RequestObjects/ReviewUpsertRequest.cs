using System;

namespace Gymify.Model.RequestObjects
{
    public class ReviewUpsertRequest
    {
        public int UserId { get; set; }
        public string Message { get; set; }
        public int StarNumber { get; set; }
    }
}
