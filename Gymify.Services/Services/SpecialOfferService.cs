using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class SpecialOfferService : BaseCRUDService<SpecialOfferResponse, BaseSearchObject, SpecialOffer, SpecialOfferUpsertRequest, SpecialOfferUpsertRequest>, ISpecialOfferService
    {
        public SpecialOfferService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
