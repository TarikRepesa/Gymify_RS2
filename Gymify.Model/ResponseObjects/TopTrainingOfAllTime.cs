namespace Gymify.Model.ResponseObjects
{
    public class TopTrainingAllTimeReportItem
    {
        public int TrainingId { get; set; }
        public string Name { get; set; } = "Trening";
        public int ParticipatedOfAllTime { get; set; }
        public int TrainerId { get; set; }
        public string TrainerName { get; set; } = "Trener";
    }
}