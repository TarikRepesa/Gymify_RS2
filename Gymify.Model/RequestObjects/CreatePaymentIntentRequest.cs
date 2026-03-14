namespace Gymify.Model.RequestObjects
{
    public class CreatePaymentIntentRequest
    {
        public int UserId { get; set; }
        public int MembershipId { get; set; }
        public string BillingPeriod { get; set; } = "monthly";
    }
}