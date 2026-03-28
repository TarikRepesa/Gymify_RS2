namespace Gymify.Model.SearchObjects
{
    public class LoyaltyPointSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public bool? IncludeUser {get; set;}
    }
}