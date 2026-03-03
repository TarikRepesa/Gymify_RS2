using Gymify.Model.SearchObjects;

namespace Gymify.Model.SearchObjects
{
    public class PaymentSearchObject : BaseSearchObject
    {

        public bool? IncludeUser {get; set;}
        public bool? IncludeMembership {get; set;}
    }
}
