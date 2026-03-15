using Gymify.Model.ResponseObjects;
using Gymify.Model.ResponseObjects.Reports;

namespace Gymify.Services.Interfaces
{
    public interface IReportsService
    {
        Task<List<TopTrainerReportItem>> GetTopTrainersAsync(int year, int take = 5);
        Task<TopTrainingAllTimeReportItem?> GetBestTrainingAllTimeAsync();
        Task<DashboardReportResponse> GetDashboardAsync(int year, int takeTopTrainers = 5);

        MembershipRevenueSummaryResponse GetMembershipRevenueSummary(int year);
        List<IncomeByMonthResponse> GetIncomeByMonth(int year);
    }
}