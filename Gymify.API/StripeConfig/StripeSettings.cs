namespace Gymify.WebAPI.StripeConfig
{
    public class StripeSettings
    {
        public string SecretKey { get; set; } = null!;
        public string WebhookSecret { get; set; } = null!;
        public string PublishableKey {get; set;} = null;
    }
}