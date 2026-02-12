using Gymify.Model;
using Gymify.Services.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

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

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);

            optionsBuilder.ConfigureWarnings(w =>
                w.Ignore(RelationalEventId.PendingModelChangesWarning));
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            base.OnModelCreating(modelBuilder);


            modelBuilder.Entity<Reservation>()
                .HasOne(r => r.User)
                .WithMany()
                .HasForeignKey(r => r.UserId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<Training>()
                .HasOne(t => t.User)
                .WithMany() 
                .HasForeignKey(t => t.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Role>().HasData(
                new Role { Id = 1, Name = "Korisnik" },
                new Role { Id = 2, Name = "Admin" },
                new Role { Id = 3, Name = "Trener" },
                new Role { Id = 4, Name = "Radnik" }
            );

            UserHelper.CreatePasswordHash("Admin123!", out string adminHash, out string adminSalt);
            UserHelper.CreatePasswordHash("Radnik123!", out string radnikHash, out string radnikSalt);
            UserHelper.CreatePasswordHash("Trener123!", out string trenerHash, out string trenerSalt);

            modelBuilder.Entity<User>().HasData(
                new User { Id = 1, FirstName = "Tarik", LastName = "Malic", Username = "tare45", Email = "ajdin@example.com", IsActive = true, IsAdmin = true, CreatedAt = DateTime.UtcNow, PasswordHash = adminHash, PasswordSalt = adminSalt },
                new User { Id = 2, FirstName = "Amir", LastName = "Ibrahimovic", Username = "amir56", Email = "amir@example.com", IsActive = true, IsAdmin = true, CreatedAt = DateTime.UtcNow, PasswordHash = adminHash, PasswordSalt = adminSalt },

                new User { Id = 3, FirstName = "Marko", LastName = "Markovic", Username = "marko78", Email = "marko@example.com", IsActive = true, IsTrener = true, CreatedAt = DateTime.UtcNow, PasswordHash = trenerHash, PasswordSalt = trenerSalt },
                new User { Id = 4, FirstName = "Ivan", LastName = "Ivic", Username = "ivan11", Email = "ivan@example.com", IsActive = true, IsTrener = true, CreatedAt = DateTime.UtcNow, PasswordHash = trenerHash, PasswordSalt = trenerSalt },
                new User { Id = 5, FirstName = "Petar", LastName = "Petrovic", Username = "petar21", Email = "petar@example.com", IsActive = true, IsTrener = true, CreatedAt = DateTime.UtcNow, PasswordHash = trenerHash, PasswordSalt = trenerSalt },
                new User { Id = 6, FirstName = "Luka", LastName = "Lukic", Username = "luka34", Email = "luka@example.com", IsActive = true, IsTrener = true, CreatedAt = DateTime.UtcNow, PasswordHash = trenerHash, PasswordSalt = trenerSalt },

                new User { Id = 7, FirstName = "Nedim", LastName = "Nedimovic", Username = "nedim89", Email = "nedim@example.com", IsActive = true, IsRadnik = true, CreatedAt = DateTime.UtcNow, PasswordHash = radnikHash, PasswordSalt = radnikSalt },
                new User { Id = 8, FirstName = "Amela", LastName = "Amelovic", Username = "amela900", Email = "amela@example.com", IsActive = true, IsRadnik = true, CreatedAt = DateTime.UtcNow, PasswordHash = radnikHash, PasswordSalt = radnikSalt },
                new User { Id = 9, FirstName = "Tarik", LastName = "Tarikovic", Username = "tarik345", Email = "tarik@example.com", IsActive = true, IsRadnik = true, CreatedAt = DateTime.UtcNow, PasswordHash = radnikHash, PasswordSalt = radnikSalt },
                new User { Id = 10, FirstName = "Emina", LastName = "Eminovic", Username = "emina112", Email = "emina@example.com", IsActive = true, IsRadnik = true, CreatedAt = DateTime.UtcNow, PasswordHash = radnikHash, PasswordSalt = radnikSalt }
            );

            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { Id = 1, UserId = 1, RoleId = 2 },
                new UserRole { Id = 2, UserId = 2, RoleId = 2 },

                new UserRole { Id = 3, UserId = 3, RoleId = 3 },
                new UserRole { Id = 4, UserId = 4, RoleId = 3 },
                new UserRole { Id = 5, UserId = 5, RoleId = 3 },
                new UserRole { Id = 6, UserId = 6, RoleId = 3 },


                new UserRole { Id = 7, UserId = 7, RoleId = 4 },
                new UserRole { Id = 8, UserId = 8, RoleId = 4 },
                new UserRole { Id = 9, UserId = 9, RoleId = 4 },
                new UserRole { Id = 10, UserId = 10, RoleId = 4 }
            );
        }
    }
}