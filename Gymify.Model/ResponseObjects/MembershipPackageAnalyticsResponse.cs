namespace Gymify.Model.ResponseObjects
{
    public class MembershipPackageAnalyticsResponse
    {
        public int MembershipId { get; set; }
        public string MembershipName { get; set; } = string.Empty;
        public int PurchaseCount { get; set; }
        public decimal TotalIncome { get; set; }
    }
}