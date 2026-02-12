using System;

namespace Gymify.Model.ResponseObjects
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int MembershipId { get; set; }
        public double Amount { get; set; }
        public DateTime PaymentDate { get; set; }
    }
}
