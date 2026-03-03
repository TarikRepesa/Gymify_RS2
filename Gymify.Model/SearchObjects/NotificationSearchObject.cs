
using System;

namespace Gymify.Model.SearchObjects
{
    public class NotificationSearchObject : BaseSearchObject
    {

        public string? SortBy {get; set;}

        public string? SortDirection {get; set;}

        //Search
        public int? UserId {get; set;}

        // Include
        public bool? IncludeUser {get; set;}
    }
}
