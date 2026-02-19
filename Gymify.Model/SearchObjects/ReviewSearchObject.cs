using Gymify.Model.SearchObjects;

namespace Gymify.Model.SearchObjects
{
    public class ReviewSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public int? StarNumber { get; set; }

        public bool? IncludeUser { get; set; }
    }
}
