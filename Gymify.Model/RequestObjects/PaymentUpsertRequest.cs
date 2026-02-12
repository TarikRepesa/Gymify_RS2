using System;

namespace Gymify.Model.RequestObjects
{
    public class PaymentUpsertRequest
    {
        public int UserId { get; set; }
        public int MembershipId { get; set; }
        public double Amount { get; set; }
        public DateTime PaymentDate { get; set; }
    }
}
