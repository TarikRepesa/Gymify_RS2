using System.IO;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Stripe;

using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Gymify.Services.Database;
using Gymify.WebAPI.StripeConfig;

namespace Gymify.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PaymentController
        : BaseCRUDController<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        private readonly GymifyDbContext _context;
        private readonly IStripeService _stripeService;
        private readonly StripeSettings _stripeSettings;
        private readonly IPaymentService _paymentService;

        public PaymentController(
    IPaymentService service,
    GymifyDbContext context,
    IStripeService stripeService,
    StripeSettings stripeSettings
) : base(service)
        {
            _paymentService = service;
            _context = context;
            _stripeService = stripeService;
            _stripeSettings = stripeSettings;
        }

        [HttpPost("create-new-intent")]
        public async Task<IActionResult> CreateNewPaymentIntent([FromBody] CreatePaymentIntentRequest req)
        {
            var result = await _paymentService.CreateNewPaymentIntentAsync(req);
            return Ok(result);
        }

        [AllowAnonymous]
        [HttpPost("webhook")]
        public async Task<IActionResult> StripeWebhook()
        {
            var json = await new StreamReader(HttpContext.Request.Body).ReadToEndAsync();
            var signatureHeader = Request.Headers["Stripe-Signature"].ToString();

            var stripeEvent = EventUtility.ConstructEvent(
                json,
                signatureHeader,
                _stripeSettings.WebhookSecret
            );

            var paymentIntent = stripeEvent.Data.Object as PaymentIntent;
            if (paymentIntent == null)
                return Ok();

            if (stripeEvent.Type == "payment_intent.succeeded")
            {
                await _paymentService.HandlePaymentIntentSucceededAsync(
                    paymentIntent.Id,
                    paymentIntent.Metadata
                );
            }
            else if (stripeEvent.Type == "payment_intent.payment_failed")
            {
                await _paymentService.HandlePaymentIntentFailedAsync(
                    paymentIntent.Id,
                    paymentIntent.Metadata
                );
            }
            else if (stripeEvent.Type == "payment_intent.canceled")
            {
                await _paymentService.HandlePaymentIntentCanceledAsync(
                    paymentIntent.Id,
                    paymentIntent.Metadata
                );
            }

            return Ok();
        }
    }
}