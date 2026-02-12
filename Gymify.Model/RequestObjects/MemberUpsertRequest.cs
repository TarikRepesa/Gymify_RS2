using System;

namespace Gymify.Model.RequestObjects
{
    public class MemberUpsertRequest
    {
        public int UserId { get; set; }
        public int MembershipId { get; set; }
        public DateTime PaymentDate { get; set; }
        public DateTime ExpirationDate { get; set; }
    }
}
