using Gymify.Model.ResponseObjects;
using Gymify.Model.ResponseObjects.Reports;
using Stripe;

namespace Gymify.Services.Interfaces
{
    public interface IStripeService
    {
        Task<PaymentIntent> CreatePaymentIntentAsync(
            decimal amount,
            string currency,
            Dictionary<string, string> metadata);
        
    }
}

