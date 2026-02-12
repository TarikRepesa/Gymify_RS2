using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class RoleController : BaseCRUDController<RoleResponse, BaseSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(IRoleService service) : base(service)
        {
        }
    }
}
