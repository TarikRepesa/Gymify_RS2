using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class PaymentService : BaseCRUDService<PaymentResponse, BaseSearchObject, Payment, PaymentUpsertRequest, PaymentUpsertRequest>, IPaymentService
    {
        public PaymentService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
