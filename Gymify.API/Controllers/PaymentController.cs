using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    
    public class PaymentController : BaseCRUDController<PaymentResponse, BaseSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        public PaymentController(IPaymentService service) : base(service)
        {
        }
    }
}
