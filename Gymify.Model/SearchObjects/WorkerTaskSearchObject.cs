
namespace Gymify.Model.SearchObjects
{
    public class WorkerTaskSearchObject : BaseSearchObject
    {
        //Search
        public int? UserId {get; set;}

        // Include
        public bool? IncludeUser {get; set;}
    }
}
