using Microsoft.EntityFrameworkCore;
using Gymify.Model.ResponseObjects;
using Gymify.Model.ResponseObjects.Reports;
using Gymify.Services.Database;
using Gymify.Services.Interfaces;

public class ReportService : IReportsService
{
    private readonly GymifyDbContext _context;

    public ReportService(GymifyDbContext context)
    {
        _context = context;
    }

    private int GetMaxMonthForYear(int year)
    {
        var today = DateTime.Today;
        int currentYear = today.Year;
        int currentMonth = today.Month;

        if (year < currentYear)
            return 12;

        if (year == currentYear)
            return currentMonth - 1;

        return 0;
    }

    public async Task<TopTrainingAllTimeReportItem?> GetBestTrainingAllTimeAsync()
    {
        var best = await _context.Trainings
            .AsNoTracking()
            .Include(t => t.User)
            .OrderByDescending(t => t.ParticipatedOfAllTime)
            .Select(t => new TopTrainingAllTimeReportItem
            {
                TrainingId = t.Id,
                Name = t.Name ?? "Trening",
                ParticipatedOfAllTime = t.ParticipatedOfAllTime,
                TrainerId = t.UserId,
                TrainerName =
                    (((t.User!.FirstName ?? "") + " " + (t.User!.LastName ?? "")).Trim().Length > 0)
                        ? ((t.User!.FirstName ?? "") + " " + (t.User!.LastName ?? "")).Trim()
                        : (t.User!.Username ?? "Trener")
            })
            .FirstOrDefaultAsync();

        return best;
    }

    public async Task<List<TopTrainerReportItem>> GetTopTrainersAsync(int year, int take = 5)
    {
        int maxMonth = GetMaxMonthForYear(year);

        if (maxMonth <= 0)
            return new List<TopTrainerReportItem>();

        var cutoffDate = GetReportCutoffDate(year);

        var result = await _context.Reservations
            .AsNoTracking()
            .Include(r => r.Training)
                .ThenInclude(t => t.User)
            .Where(r =>
                r.Status == "Confirmed" &&
                r.Training != null &&
                r.Training.User != null &&
                r.Training.StartDate.Year == year &&
                r.Training.StartDate <= cutoffDate)
            .GroupBy(r => new
            {
                TrainerId = r.Training!.UserId,
                FirstName = r.Training.User!.FirstName,
                LastName = r.Training.User!.LastName,
                Username = r.Training.User!.Username
            })
            .Select(g => new TopTrainerReportItem
            {
                TrainerId = g.Key.TrainerId,
                Name = ((g.Key.FirstName ?? "") + " " + (g.Key.LastName ?? "")).Trim().Length > 0
                    ? ((g.Key.FirstName ?? "") + " " + (g.Key.LastName ?? "")).Trim()
                    : (g.Key.Username ?? "Trener"),
                Count = g.Count()
            })
            .OrderByDescending(x => x.Count)
            .ThenBy(x => x.Name)
            .Take(take)
            .ToListAsync();

        return result;
    }

    public async Task<DashboardReportResponse> GetDashboardAsync(int year, int takeTopTrainers = 5)
    {
        var top = await GetTopTrainersAsync(year, takeTopTrainers);
        var bestTraining = await GetBestTrainingAllTimeAsync();

        return new DashboardReportResponse
        {
            TopTrainers = top,
            BestTrainingAllTime = bestTraining
        };
    }

    public MembershipRevenueSummaryResponse GetMembershipRevenueSummary(int year)
    {
        int maxMonth = GetMaxMonthForYear(year);

        if (maxMonth <= 0)
        {
            return new MembershipRevenueSummaryResponse
            {
                Year = year,
                TotalIncome = 0,
                TotalPayments = 0,
                ActiveMembers = 0,
                ExpiredMembers = 0,
                MonthlyIncome = new List<IncomeByMonthResponse>(),
                PackageAnalytics = new List<MembershipPackageAnalyticsResponse>()
            };
        }

        var paidPayments = _context.Payments
            .AsNoTracking()
            .Include(p => p.Membership)
            .Where(p =>
                p.PaymentStatus == "Paid" &&
                p.PaymentDate.Year == year &&
                p.PaymentDate.Month <= maxMonth);

        var totalIncomeRaw = paidPayments.Sum(p => (decimal?)p.Amount) ?? 0m;
        var totalIncome = (int)totalIncomeRaw;

        var totalPayments = paidPayments.Count();

        var cutoffDate = GetReportCutoffDate(year);

        var filteredMembers = _context.Members
            .AsNoTracking()
            .Where(m =>
                m.PaymentDate.Year == year &&
                m.PaymentDate.Month <= maxMonth);

        var activeMembers = filteredMembers.Count(m => m.ExpirationDate >= cutoffDate);
        var expiredMembers = filteredMembers.Count(m => m.ExpirationDate < cutoffDate);

        var packageAnalyticsRaw = paidPayments
            .GroupBy(p => new { p.MembershipId, p.Membership.Name })
            .Select(g => new
            {
                MembershipId = g.Key.MembershipId,
                MembershipName = g.Key.Name,
                PurchaseCount = g.Count(),
                TotalIncome = g.Sum(x => x.Amount)
            })
            .OrderByDescending(x => x.TotalIncome)
            .ToList();

        var packageAnalytics = packageAnalyticsRaw
            .Select(g => new MembershipPackageAnalyticsResponse
            {
                MembershipId = g.MembershipId,
                MembershipName = g.MembershipName,
                PurchaseCount = g.PurchaseCount,
                TotalIncome = (int)g.TotalIncome
            })
            .OrderByDescending(x => x.TotalIncome)
            .ToList();

        return new MembershipRevenueSummaryResponse
        {
            Year = year,
            TotalIncome = totalIncome,
            TotalPayments = totalPayments,
            ActiveMembers = activeMembers,
            ExpiredMembers = expiredMembers,
            MonthlyIncome = GetIncomeByMonth(year),
            PackageAnalytics = packageAnalytics
        };
    }

    private DateTime GetReportCutoffDate(int year)
    {
        var today = DateTime.Today;

        if (year < today.Year)
            return new DateTime(year, 12, 31);

        if (year == today.Year)
        {
            int lastMonth = today.Month - 1;

            if (lastMonth <= 0)
                return new DateTime(year, 1, 1).AddDays(-1);

            return new DateTime(year, lastMonth, DateTime.DaysInMonth(year, lastMonth));
        }

        return new DateTime(year, 1, 1).AddDays(-1);
    }

    public List<IncomeByMonthResponse> GetIncomeByMonth(int year)
    {
        int maxMonth = GetMaxMonthForYear(year);

        if (maxMonth <= 0)
            return new List<IncomeByMonthResponse>();

        var result = _context.Payments
            .AsNoTracking()
            .Where(p =>
                p.PaymentStatus == "Paid" &&
                p.PaymentDate.Year == year &&
                p.PaymentDate.Month <= maxMonth)
            .GroupBy(p => p.PaymentDate.Month)
            .Select(g => new IncomeByMonthResponse
            {
                Month = g.Key,
                TotalIncome = g.Sum(x => (double)x.Amount),
                PaymentCount = g.Count()
            })
            .OrderBy(x => x.Month)
            .ToList();

        var monthLabels = new[]
        {
            "", "Jan", "Feb", "Mar", "Apr", "Maj", "Jun",
            "Jul", "Avg", "Sep", "Okt", "Nov", "Dec"
        };

        return Enumerable.Range(1, maxMonth)
            .Select(month => new IncomeByMonthResponse
            {
                Month = month,
                Label = monthLabels[month],
                TotalIncome = result.FirstOrDefault(x => x.Month == month)?.TotalIncome ?? 0d,
                PaymentCount = result.FirstOrDefault(x => x.Month == month)?.PaymentCount ?? 0
            })
            .ToList();
    }
}

internal static class EnumerableAsyncHelper
{
    public static Task<List<T>> ToListAsyncSafe<T>(this IEnumerable<T> source)
    {
        return Task.FromResult(source.ToList());
    }
}