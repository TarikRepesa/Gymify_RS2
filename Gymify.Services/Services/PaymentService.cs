using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Services
{
    public class PaymentService : BaseCRUDService<PaymentResponse, PaymentSearchObject, Payment, PaymentUpsertRequest, PaymentUpsertRequest>, IPaymentService
    {
        public PaymentService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Payment> AddInclude(IQueryable<Payment> query, PaymentSearchObject search)
        {
            if (search.IncludeUser.HasValue)
            {
                query = query.Include(x => x.User);
            }

            if (search.IncludeMembership.HasValue)
            {
                query = query.Include(x => x.Membership);
            }
            return base.AddInclude(query, search);
        }
    }
}
