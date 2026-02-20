using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class WorkerTaskController : BaseCRUDController<WorkerTaskResponse, WorkerTaskSearchObject, WorkerTaskUpsertRequest, WorkerTaskUpsertRequest>
    {
        public WorkerTaskController(IWorkerTaskService service) : base(service)
        {
        }
    }
}
