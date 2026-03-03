using Gymify.Model.SearchObjects;

namespace Gymify.Model.SearchObjects
{
    public class ReservationSearchObject : BaseSearchObject
    {
        public bool? IncludeUser {get; set;}
        public bool? IncludeTraining {get; set;}
    }
}
