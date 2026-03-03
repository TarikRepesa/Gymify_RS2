using System;

namespace Gymify.Model.RequestObjects
{
    public class MemberUpdateRequest
    {
        public int MembershipId { get; set; }
        public DateTime PaymentDate { get; set; }
        public DateTime ExpirationDate { get; set; }
    }
}
