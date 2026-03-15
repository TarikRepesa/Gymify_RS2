using Gymify.Services.Database;

public class MembershipSeedBundle
{
    public List<Member> Members { get; set; } = new();
    public List<Payment> Payments { get; set; } = new();
}