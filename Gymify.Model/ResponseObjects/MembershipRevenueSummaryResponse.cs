using System.Collections.Generic;

namespace Gymify.Model.ResponseObjects
{
    public class MembershipRevenueSummaryResponse
    {
        public int Year { get; set; }
        public int TotalIncome { get; set; }
        public int TotalPayments { get; set; }
        public int ActiveMembers { get; set; }
        public int ExpiredMembers { get; set; }
        public List<IncomeByMonthResponse> MonthlyIncome { get; set; }
        public List<MembershipPackageAnalyticsResponse> PackageAnalytics { get; set; }
    }
}