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

    if (!string.IsNullOrEmpty(search.SortBy))
    {
        if (search.SortBy == "createdAt")
        {
            query = search.SortDirection == "desc"
                ? query.OrderByDescending(x => x.CreatedAt)
                : query.OrderBy(x => x.CreatedAt);
        }
    }

    if (!string.IsNullOrWhiteSpace(search.FTS))
    {
        var fts = search.FTS.ToLower();

        query = query.Where(x =>
            x.Title.ToLower().Contains(fts) ||
            x.Content.ToLower().Contains(fts) ||
            (x.User != null && x.User.FirstName.ToLower().Contains(fts)) ||
            (x.User != null && x.User.LastName.ToLower().Contains(fts)) ||
            (x.User != null &&
             (x.User.FirstName + " " + x.User.LastName).ToLower().Contains(fts))
        );
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

        protected override Task BeforeInsert(Notification entity, NotificationUpsertRequest request)
        {
            entity.CreatedAt = DateTime.Now;
            return base.BeforeInsert(entity, request);
        }
    }
}
