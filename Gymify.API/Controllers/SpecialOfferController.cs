using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class SpecialOfferController : BaseCRUDController<SpecialOfferResponse, BaseSearchObject, SpecialOfferUpsertRequest, SpecialOfferUpsertRequest>
    {
        public SpecialOfferController(ISpecialOfferService service) : base(service)
        {
        }
    }
}
