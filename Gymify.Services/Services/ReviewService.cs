using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Services
{
    public class ReviewService
        : BaseCRUDService<
            ReviewResponse,
            ReviewSearchObject,
            Review,
            ReviewUpsertRequest,
            ReviewUpsertRequest>,
          IReviewService
    {
        public ReviewService(GymifyDbContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        protected override IQueryable<Review> ApplyFilter(
            IQueryable<Review> query,
            ReviewSearchObject search)
        {
            query = base.ApplyFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                var fts = search.FTS.ToLower();

                query = query.Where(x =>
                    x.Message.ToLower().Contains(fts) ||
                    x.User.FirstName.ToLower().Contains(fts) ||
                    x.User.LastName.ToLower().Contains(fts)
                );
            }

            if (search?.StarNumber != null)
            {
                query = query.Where(x => x.StarNumber == search.StarNumber);
            }

            return query;
        }

        protected override IQueryable<Review> AddInclude(
            IQueryable<Review> query,
            ReviewSearchObject search)
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
