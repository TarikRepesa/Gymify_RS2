namespace Gymify.Model.ResponseObjects
{
    public class TopTrainerReportItem
    {
        public int TrainerId { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Count { get; set; }
    }
}