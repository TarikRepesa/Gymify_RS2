namespace Gymify.Model.ResponseObjects
{
    public class MembershipReportItem
    {
        public int MembershipId { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Count { get; set; }
    }
}