
namespace Gymify.Model.SearchObjects
{
    public class NotificationSearchObject : BaseSearchObject
    {
        //Search
        public int? UserId {get; set;}

        // Include
        public bool? IncludeUser {get; set;}
    }
}
