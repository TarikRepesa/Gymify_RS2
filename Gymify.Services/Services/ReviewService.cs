using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class ReviewService : BaseCRUDService<ReviewResponse, BaseSearchObject, Review, ReviewUpsertRequest, ReviewUpsertRequest>, IReviewService
    {
        public ReviewService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
