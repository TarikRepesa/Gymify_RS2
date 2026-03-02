
using System;

namespace Gymify.Model.SearchObjects
{
    public class TrainingSearchObject : BaseSearchObject
    {
        public int? UserId {get; set;}
        public bool? IncludeUser {get; set;}
        public DateTime? StartDate {get; set;}
    }
}
