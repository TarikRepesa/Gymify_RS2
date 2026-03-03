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

    public async Task<TopTrainingAllTimeReportItem?> GetBestTrainingAllTimeAsync()
    {
        // Pretpostavke:
        // - Training.UserId = trener
        // - Training.User navigacija postoji (ili bar User tabela postoji)
        // - Training.ParicipatedOfAllTime postoji

        var best = await _context.Trainings
            .AsNoTracking()
            .Include(t => t.User) // ako nemaš User navigaciju, javi pa ću ti dati varijantu bez Include
            .OrderByDescending(t => t.ParicipatedOfAllTime)
            .Select(t => new TopTrainingAllTimeReportItem
            {
                TrainingId = t.Id,
                Name = t.Name ?? "Trening",
                ParticipatedOfAllTime = t.ParicipatedOfAllTime,
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
        var from = new DateTime(year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        var to = new DateTime(year + 1, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        var result = await _context.Reservations
            .AsNoTracking()
            .Where(r => r.Training != null
                        && r.Training.StartDate >= from
                        && r.Training.StartDate < to)
            .GroupBy(r => new
            {
                TrainerId = r.Training!.UserId,
                FirstName = r.Training!.User!.FirstName,
                LastName = r.Training!.User!.LastName,
                Username = r.Training!.User!.Username
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
}