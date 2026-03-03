namespace Gymify.Model.ResponseObjects
{
    public class RewardResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public int RequiredPoints { get; set; }
        public bool IsActive { get; set; }
    }
}