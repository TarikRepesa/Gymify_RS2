namespace Gymify.Services.Recommender
{
    public class TrainingFeatureVector
    {
        public float Morning { get; set; }
        public float Afternoon { get; set; }
        public float Evening { get; set; }

        public float DurationMinutes { get; set; }
        public float IntensityLevel { get; set; }

        public float Strength { get; set; }
        public float WeightLoss { get; set; }
        public float Cardio { get; set; }
        public float MartialArts { get; set; }
        public float Flexibility { get; set; }
    }
}