using Gymify.Model.SearchObjects;

namespace Gymify.Model.SearchObjects
{
    public class ReservationSearchObject : BaseSearchObject
    {
        public int? UserId {get; set;}
        public bool? IncludeUser {get; set;}
        public bool? IncludeTraining {get; set;}
        public string? Status {get; set;}
    }
}
