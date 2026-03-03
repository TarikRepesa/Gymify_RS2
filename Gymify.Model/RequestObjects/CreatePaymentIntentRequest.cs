public class CreatePaymentIntentRequest
{
    public int UserId { get; set; }
    public int MembershipId { get; set; }
    public double Amount { get; set; }
}