using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    
    public class MemberController : BaseCRUDController<MemberResponse, BaseSearchObject, MemberUpsertRequest, MemberUpsertRequest>
    {
        public MemberController(IMemberService service) : base(service)
        {
        }
    }
}
