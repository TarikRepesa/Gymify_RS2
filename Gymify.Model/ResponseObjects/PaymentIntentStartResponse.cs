namespace Gymify.Model.ResponseObjects
{
    public class PaymentIntentStartResponse
    {
        public string ClientSecret { get; set; } = string.Empty;
        public string IntentId { get; set; } = string.Empty;
        public int PaymentId { get; set; }
        public decimal Amount { get; set; }
        public string BillingPeriod { get; set; } = string.Empty;
    }
}