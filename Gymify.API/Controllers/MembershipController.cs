using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class MembershipController : BaseCRUDController<MembershipResponse, BaseSearchObject, MembershipUpsertRequest, MembershipUpsertRequest>
    {
        public MembershipController(IMembershipService service) : base(service)
        {
        }
    }
}
