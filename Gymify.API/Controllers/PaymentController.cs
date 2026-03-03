using System.IO;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Stripe;

using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Gymify.Services.Database;
using Gymify.WebAPI.Services;
using Gymify.WebAPI.StripeConfig;


namespace Gymify.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PaymentController
        : BaseCRUDController<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        private readonly GymifyDbContext _context;
        private readonly StripeService _stripeService;
        private readonly StripeSettings _stripeSettings;

        public PaymentController(
            IPaymentService service,
            GymifyDbContext context,
            StripeService stripeService,
            IOptions<StripeSettings> stripeOptions
        ) : base(service)
        {
            _context = context;
            _stripeService = stripeService;
            _stripeSettings = stripeOptions.Value;
        }

        // POST: api/payment/{id}/create-intent
        [HttpPost("{id:int}/create-intent")]
        public async Task<IActionResult> CreatePaymentIntent(int id)
        {
            // prilagodi naziv DbSet-a ako se ne zove Payments
            var payment = await _context.Payments.FirstOrDefaultAsync(x => x.Id == id);
            if (payment == null)
                return NotFound("Payment nije pronađen.");

            var metadata = new Dictionary<string, string>
            {
                ["paymentId"] = payment.Id.ToString(),
                ["userId"] = payment.UserId.ToString(),
                ["membershipId"] = payment.MembershipId.ToString()
            };

            var intent = await _stripeService.CreatePaymentIntentAsync(
                amount: payment.Amount,
                currency: "bam",
                metadata: metadata
            );

            payment.StripePaymentIntentId = intent.Id;
            payment.PaymentStatus = "Processing";

            await _context.SaveChangesAsync();

            return Ok(new
            {
                clientSecret = intent.ClientSecret
            });
        }

        [HttpPost("/create-new-intent")]
        public async Task<IActionResult> CreateNewPaymentIntent([FromBody] CreatePaymentIntentRequest req)
        {
            var metadata = new Dictionary<string, string>
            {
                ["userId"] = req.UserId.ToString(),
                ["membershipId"] = req.MembershipId.ToString(),
                ["isFirstPayment"] = "true"
            };

            var intent = await _stripeService.CreatePaymentIntentAsync(
                amount: req.Amount,
                currency: "bam",
                metadata: metadata
            );

            return Ok(new
            {
                clientSecret = intent.ClientSecret,
                intentId = intent.Id
            });
        }

        [AllowAnonymous]
        [HttpPost("webhook")]
        public async Task<IActionResult> StripeWebhook()
        {
            var json = await new StreamReader(HttpContext.Request.Body).ReadToEndAsync();

            try
            {
                var signatureHeader = Request.Headers["Stripe-Signature"].ToString();

                var stripeEvent = EventUtility.ConstructEvent(
                    json,
                    signatureHeader,
                    _stripeSettings.WebhookSecret
                );

                if (stripeEvent.Type == "payment_intent.succeeded")
                {
                    var paymentIntent = stripeEvent.Data.Object as PaymentIntent;
                    if (paymentIntent?.Metadata == null)
                        return Ok();

                    if (!paymentIntent.Metadata.TryGetValue("paymentId", out var paymentIdString))
                        return Ok();

                    if (!int.TryParse(paymentIdString, out var paymentId))
                        return Ok();

                    var payment = await _context.Payments.FirstOrDefaultAsync(x => x.Id == paymentId);
                    if (payment == null)
                        return Ok();

                    payment.PaymentStatus = "Paid";
                    payment.PaidAt = DateTime.UtcNow;
                    payment.StripePaymentIntentId = paymentIntent.Id;

                    // opcionalno: upiši i PaymentDate ako ti treba kao datum evidencije
                    payment.PaymentDate = DateTime.UtcNow;

                    await _context.SaveChangesAsync();
                }
                else if (stripeEvent.Type == "payment_intent.payment_failed")
                {
                    var paymentIntent = stripeEvent.Data.Object as PaymentIntent;
                    if (paymentIntent?.Metadata == null)
                        return Ok();

                    if (paymentIntent.Metadata.TryGetValue("paymentId", out var paymentIdString) &&
                        int.TryParse(paymentIdString, out var paymentId))
                    {
                        var payment = await _context.Payments.FirstOrDefaultAsync(x => x.Id == paymentId);
                        if (payment != null)
                        {
                            payment.PaymentStatus = "Failed";
                            payment.StripePaymentIntentId = paymentIntent.Id;
                            await _context.SaveChangesAsync();
                        }
                    }
                }

                return Ok();
            }
            catch (StripeException e)
            {
                return BadRequest($"Stripe error: {e.Message}");
            }
            catch (Exception e)
            {
                return BadRequest($"Webhook error: {e.Message}");
            }
        }
    }
}