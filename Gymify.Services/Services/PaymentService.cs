using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Gymify.EmailConsumer.Configuration;
using Microsoft.Extensions.Options;
using Gymify.Services.Exceptions;

namespace Gymify.Services.Services
{
    public class PaymentService : BaseCRUDService<PaymentResponse, PaymentSearchObject, Payment, PaymentUpsertRequest, PaymentUpsertRequest>, IPaymentService
    {
        private readonly IStripeService _stripeService;
        private readonly AppConfig _config;
        public PaymentService(GymifyDbContext context, IMapper mapper, IStripeService st, IOptions<AppConfig> config) : base(context, mapper)
        {
            _stripeService = st;
            _config = config.Value;
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

        public async Task<object> CreateNewPaymentIntentAsync(CreatePaymentIntentRequest req)
        {
            var membership = await _context.Memberships
                .FirstOrDefaultAsync(x => x.Id == req.MembershipId);

            if (membership == null)
                throw new NotFoundException("Membership nije pronađen.");

            var userExists = await _context.Users.AnyAsync(x => x.Id == req.UserId);
            if (!userExists)
                throw new NotFoundException("User nije pronađen.");

            var billingPeriod = (req.BillingPeriod ?? "monthly").Trim().ToLower();

            if (billingPeriod != "monthly" && billingPeriod != "yearly")
                throw new UserException("BillingPeriod mora biti 'monthly' ili 'yearly'.");

            var amount = billingPeriod == "yearly"
                ? membership.YearPrice
                : membership.MonthlyPrice;

            var existingMember = await _context.Members
                .FirstOrDefaultAsync(x => x.UserId == req.UserId);

            var isFirstPayment = existingMember == null;

            var payment = new Payment
            {
                UserId = req.UserId,
                MembershipId = req.MembershipId,
                Amount = amount,
                PaymentDate = DateTime.UtcNow,
                PaymentStatus = "Pending",
                BillingPeriod = billingPeriod
            };

            _context.Payments.Add(payment);
            await _context.SaveChangesAsync();

            var metadata = new Dictionary<string, string>
            {
                ["paymentId"] = payment.Id.ToString(),
                ["userId"] = payment.UserId.ToString(),
                ["membershipId"] = payment.MembershipId.ToString(),
                ["billingPeriod"] = billingPeriod,
                ["isFirstPayment"] = isFirstPayment.ToString().ToLower()
            };

            var intent = await _stripeService.CreatePaymentIntentAsync(
                amount,
                _config.PaymentCurrency,
                metadata
            );

            payment.StripePaymentIntentId = intent.Id;
            payment.PaymentStatus = "Processing";

            await _context.SaveChangesAsync();

            return new
            {
                clientSecret = intent.ClientSecret,
                intentId = intent.Id,
                paymentId = payment.Id,
                amount,
                billingPeriod
            };
        }

        public async Task HandlePaymentIntentSucceededAsync(string paymentIntentId, Dictionary<string, string> metadata)
        {
            if (!metadata.TryGetValue("paymentId", out var paymentIdString))
                return;

            if (!int.TryParse(paymentIdString, out var paymentId))
                return;

            var payment = await _context.Payments.FirstOrDefaultAsync(x => x.Id == paymentId);
            if (payment == null || payment.PaymentStatus == "Paid")
                return;

            payment.PaymentStatus = "Paid";
            payment.PaidAt = DateTime.UtcNow;
            payment.PaymentDate = DateTime.UtcNow;
            payment.StripePaymentIntentId = paymentIntentId;

            var member = await _context.Members.FirstOrDefaultAsync(x => x.UserId == payment.UserId);

            var billingPeriod = metadata.TryGetValue("billingPeriod", out var bp)
                ? bp?.Trim().ToLower()
                : payment.BillingPeriod?.Trim().ToLower();

            billingPeriod ??= "monthly";

            var now = DateTime.UtcNow;

            if (member == null)
            {
                _context.Members.Add(new Member
                {
                    UserId = payment.UserId,
                    MembershipId = payment.MembershipId,
                    PaymentDate = now,
                    ExpirationDate = billingPeriod == "yearly"
                        ? now.AddYears(1)
                        : now.AddMonths(1)
                });
            }
            else
            {
                var baseDate = member.ExpirationDate > now ? member.ExpirationDate : now;

                member.MembershipId = payment.MembershipId;
                member.PaymentDate = now;
                member.ExpirationDate = billingPeriod == "yearly"
                    ? baseDate.AddYears(1)
                    : baseDate.AddMonths(1);
            }

            await _context.SaveChangesAsync();
        }

        public async Task HandlePaymentIntentFailedAsync(string paymentIntentId, Dictionary<string, string> metadata)
        {
            if (!metadata.TryGetValue("paymentId", out var paymentIdString))
                return;

            if (!int.TryParse(paymentIdString, out var paymentId))
                return;

            var payment = await _context.Payments.FirstOrDefaultAsync(x => x.Id == paymentId);
            if (payment == null || payment.PaymentStatus == "Paid")
                return;

            payment.PaymentStatus = "Failed";
            payment.StripePaymentIntentId = paymentIntentId;

            await _context.SaveChangesAsync();
        }

        public async Task HandlePaymentIntentCanceledAsync(string paymentIntentId, Dictionary<string, string> metadata)
        {
            if (!metadata.TryGetValue("paymentId", out var paymentIdString))
                return;

            if (!int.TryParse(paymentIdString, out var paymentId))
                return;

            var payment = await _context.Payments.FirstOrDefaultAsync(x => x.Id == paymentId);
            if (payment == null || payment.PaymentStatus == "Paid")
                return;

            payment.PaymentStatus = "Canceled";
            payment.StripePaymentIntentId = paymentIntentId;

            await _context.SaveChangesAsync();
        }

        public Task<object> CreatePaymentIntentForExistingPaymentAsync(int id)
        {
            throw new NotImplementedException();
        }


    }
}
