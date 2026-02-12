using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class RoleService : BaseCRUDService<RoleResponse, BaseSearchObject, Role, RoleUpsertRequest, RoleUpsertRequest>, IRoleService
    {
        public RoleService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
