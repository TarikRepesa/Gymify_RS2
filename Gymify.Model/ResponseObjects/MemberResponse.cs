using System;

namespace Gymify.Model.ResponseObjects
{
    public class MemberResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int MembershipId { get; set; }
        public DateTime PaymentDate { get; set; }
        public DateTime ExpirationDate { get; set; }
    }
}
