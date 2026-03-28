using Gymify.Services.Database;

namespace Gymify.Services.Seed
{
    public class MembershipSeedBundle
    {
        public List<Member> Members { get; set; } = new();
        public List<Payment> Payments { get; set; } = new();
    }

}