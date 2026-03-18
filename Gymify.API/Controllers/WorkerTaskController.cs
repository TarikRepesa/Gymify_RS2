using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Get: Radnik
//Create: Admin
//Delete: Radnik
//Update: Radnik


namespace Gymify.API.Controllers
{
    public class WorkerTaskController : BaseCRUDController<WorkerTaskResponse, WorkerTaskSearchObject, WorkerTaskUpsertRequest, WorkerTaskUpsertRequest>
    {
        public WorkerTaskController(IWorkerTaskService service) : base(service)
        {
        }

        [Authorize(Roles = "Radnik")]
        public override Task<PagedResult<WorkerTaskResponse>> Get([FromQuery] WorkerTaskSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Radnik")]
        public override Task<WorkerTaskResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Radnik")]
        public override Task<WorkerTaskResponse?> Update(int id, [FromBody] WorkerTaskUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }

        [Authorize(Roles = "Admin")]
        public override Task<WorkerTaskResponse> Create([FromBody] WorkerTaskUpsertRequest request)
        {
            return base.Create(request);
        }
    }
}
