using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Services
{
    public class WorkerTaskService : BaseCRUDService<WorkerTaskResponse, WorkerTaskSearchObject, WorkerTask, WorkerTaskUpsertRequest, WorkerTaskUpsertRequest>, IWorkerTaskService
    {
        public WorkerTaskService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<WorkerTask> ApplyFilter(IQueryable<WorkerTask> query, WorkerTaskSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x => x.Name.ToLower().Contains(search.FTS.ToLower()));
            }
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId);
            }
            return base.ApplyFilter(query, search);
        }

        protected override IQueryable<WorkerTask> AddInclude(IQueryable<WorkerTask> query, WorkerTaskSearchObject search)
        {
             if (search.IncludeUser.HasValue)
            {
                query = query.Include(x => x.User);
            }
            return base.AddInclude(query, search);
        }

    }
}
