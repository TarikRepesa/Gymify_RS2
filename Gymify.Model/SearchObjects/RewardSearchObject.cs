using Gymify.Model.SearchObjects;

namespace Gymify.Model.SearchObjects
{
    public class RewardSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public bool? IsActive { get; set; }
        public int? MinRequiredPoints { get; set; }
        public int? MaxRequiredPoints { get; set; }
    }
}