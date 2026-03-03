using System.Collections.Generic;

namespace Gymify.Model.ResponseObjects.Reports
{
    public class DashboardReportResponse
    {
        public List<TopTrainerReportItem> TopTrainers { get; set; } 
        public TopTrainingAllTimeReportItem? BestTrainingAllTime { get; set; }
    }
}