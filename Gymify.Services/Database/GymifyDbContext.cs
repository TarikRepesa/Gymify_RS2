using Gymify.Model;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Database
{
    public class GymifyDbContext : DbContext
    {
        public GymifyDbContext(DbContextOptions<GymifyDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        
        public DbSet<Role> Roles { get; set; }

        public DbSet<UserRole> UserRoles { get; set; }

        public DbSet<Member> Members { get; set; }

        public DbSet<Membership> Memberships { get; set; }

        public DbSet<LoyaltyPoint> LoyaltyPoints { get; set; }

        public DbSet<LoyaltyPointHistory> LoyaltyPointHistories { get; set; }

        public DbSet<Training> Trainings { get; set; }

        public DbSet<Reservation> Reservations { get; set; }

        public DbSet<Payment> Payments { get; set; }

        public DbSet<Review> Reviews { get; set; }

        public DbSet<SpecialOffer> SpecialOffers { get; set; }
        
        public DbSet<WorkerTask> WorkerTasks { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Members>()
                .HasKey(m => m.MemberId);
        }
    }
}