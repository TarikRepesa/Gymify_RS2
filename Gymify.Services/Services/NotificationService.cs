using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Services
{
    public class NotificationService
        : BaseCRUDService<
            NotificationResponse,
            NotificationSearchObject,
            Database.Notification,
            NotificationUpsertRequest,
            NotificationUpsertRequest>,
          INotificationService
    {
        public NotificationService(GymifyDbContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        protected override IQueryable<Database.Notification> ApplyFilter(
            IQueryable<Database.Notification> query,
            NotificationSearchObject search)
        {
            query = base.ApplyFilter(query, search);

            if (search?.UserId.HasValue == true)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            return query;
        }

        protected override IQueryable<Database.Notification> AddInclude(
            IQueryable<Database.Notification> query,
            NotificationSearchObject search)
        {
            query = base.AddInclude(query, search);

            if (search?.IncludeUser == true)
            {
                query = query.Include(x => x.User);
            }

            return query;
        }
    }
}
