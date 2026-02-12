using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class WorkerTaskService : BaseCRUDService<WorkerTaskResponse, BaseSearchObject, WorkerTask, WorkerTaskUpsertRequest, WorkerTaskUpsertRequest>, IWorkerTaskService
    {
        public WorkerTaskService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
