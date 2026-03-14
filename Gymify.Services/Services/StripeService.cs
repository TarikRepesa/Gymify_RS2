using Gymify.Services.Interfaces;
using Stripe;

namespace Gymify.WebAPI.Services
{
    public class StripeService : IStripeService
    {
        public async Task<PaymentIntent> CreatePaymentIntentAsync(
            decimal amount,
            string currency,
            Dictionary<string, string> metadata)
        {
            var options = new PaymentIntentCreateOptions
            {
                
                Amount = (long)(amount * 100m),

                Currency = currency,

                AutomaticPaymentMethods = new PaymentIntentAutomaticPaymentMethodsOptions
                {
                    Enabled = true
                },

                Metadata = metadata
            };

            var service = new PaymentIntentService();
            return await service.CreateAsync(options);
        }
    }
}