using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IPaymentService : ICRUDService<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
    {
        Task<object> CreatePaymentIntentForExistingPaymentAsync(int id);
        Task<PaymentIntentStartResponse> CreateNewPaymentIntentAsync(CreatePaymentIntentRequest req);

        Task HandlePaymentIntentSucceededAsync(string paymentIntentId, Dictionary<string, string> metadata);
        Task HandlePaymentIntentFailedAsync(string paymentIntentId, Dictionary<string, string> metadata);
        Task HandlePaymentIntentCanceledAsync(string paymentIntentId, Dictionary<string, string> metadata);
    }
}
