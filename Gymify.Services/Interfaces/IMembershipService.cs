using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IMembershipService : ICRUDService<MembershipResponse, BaseSearchObject, MembershipUpsertRequest, MembershipUpsertRequest>
    {
    }
}
