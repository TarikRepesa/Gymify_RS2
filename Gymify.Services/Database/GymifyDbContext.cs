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
        public DbSet<Notification> Notifications { get; set; }
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
            UserHelper.CreatePasswordHash("User123!", out string userHash, out string userSalt);


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
                new User { Id = 10, FirstName = "Emina", LastName = "Eminovic", Username = "emina112", Email = "emina@example.com", IsActive = true, IsRadnik = true, CreatedAt = DateTime.UtcNow, PasswordHash = radnikHash, PasswordSalt = radnikSalt },
                new User { Id = 11, FirstName = "Haris", LastName = "Hasic", Username = "haris1", Email = "haris1@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 12, FirstName = "Denis", LastName = "Denisovic", Username = "denis2", Email = "denis2@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 13, FirstName = "Alen", LastName = "Alenovic", Username = "alen3", Email = "alen3@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 14, FirstName = "Kenan", LastName = "Kenanovic", Username = "kenan4", Email = "kenan4@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 15, FirstName = "Jasmin", LastName = "Jasminovic", Username = "jasmin5", Email = "jasmin5@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 16, FirstName = "Lejla", LastName = "Lejlovic", Username = "lejla6", Email = "lejla6@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 17, FirstName = "Sara", LastName = "Saric", Username = "sara7", Email = "sara7@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 18, FirstName = "Amina", LastName = "Aminovic", Username = "amina8", Email = "amina8@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 19, FirstName = "Emir", LastName = "Emirovic", Username = "emir9", Email = "emir9@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt },
                new User { Id = 20, FirstName = "Nermin", LastName = "Nerminovic", Username = "nermin10", Email = "nermin10@example.com", IsActive = true, IsUser = true, CreatedAt = DateTime.UtcNow, PasswordHash = userHash, PasswordSalt = userSalt }
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

            modelBuilder.Entity<Membership>().HasData(
    new Membership
    {
        Id = 1,
        Name = "Basic",
        MonthlyPrice = 30.00,
        YearPrice = 300.00,
        CreatedAt = new DateTime(2025, 1, 1)
    },
    new Membership
    {
        Id = 2,
        Name = "Standard",
        MonthlyPrice = 45.00,
        YearPrice = 450.00,
        CreatedAt = new DateTime(2025, 1, 1)
    },
    new Membership
    {
        Id = 3,
        Name = "Premium",
        MonthlyPrice = 60.00,
        YearPrice = 600.00,
        CreatedAt = new DateTime(2025, 1, 1)
    },
    new Membership
    {
        Id = 4,
        Name = "VIP",
        MonthlyPrice = 80.00,
        YearPrice = 800.00,
        CreatedAt = new DateTime(2025, 1, 1)
    }
);


            modelBuilder.Entity<Member>().HasData(
                new Member { Id = 1, UserId = 11, MembershipId = 1, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(30) },
                new Member { Id = 2, UserId = 12, MembershipId = 2, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(90) },
                new Member { Id = 3, UserId = 13, MembershipId = 3, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(180) },
                new Member { Id = 4, UserId = 14, MembershipId = 4, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(365) },
                new Member { Id = 5, UserId = 15, MembershipId = 1, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(-5) },
                new Member { Id = 6, UserId = 16, MembershipId = 2, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(90) },
                new Member { Id = 7, UserId = 17, MembershipId = 3, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(-10) },
                new Member { Id = 8, UserId = 18, MembershipId = 4, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(-5) },
                new Member { Id = 9, UserId = 19, MembershipId = 1, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(30) },
                new Member { Id = 10, UserId = 20, MembershipId = 2, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(-10) }
            );

            modelBuilder.Entity<Training>().HasData(
    new Training { Id = 1, UserId = 3, Name = "HIIT", MaxAmountOfParticipants = 15, CurrentParticipants = 10, StartDate = new DateTime(2026, 6, 1), TrainingImage = "https://picsum.photos/seed/hiit/600/400" },
    new Training { Id = 2, UserId = 3, Name = "Cardio Blast", MaxAmountOfParticipants = 20, CurrentParticipants = 12, StartDate = new DateTime(2026, 6, 2), TrainingImage = "https://picsum.photos/seed/cardioblast/600/400" },
    new Training { Id = 3, UserId = 4, Name = "CrossFit", MaxAmountOfParticipants = 18, CurrentParticipants = 14, StartDate = new DateTime(2026, 6, 3), TrainingImage = "https://picsum.photos/seed/crossfit/600/400" },
    new Training { Id = 4, UserId = 4, Name = "Yoga Flow", MaxAmountOfParticipants = 12, CurrentParticipants = 8, StartDate = new DateTime(2026, 6, 4), TrainingImage = "https://picsum.photos/seed/yogaflow/600/400" },
    new Training { Id = 5, UserId = 5, Name = "Pilates", MaxAmountOfParticipants = 10, CurrentParticipants = 6, StartDate = new DateTime(2026, 6, 5), TrainingImage = "https://picsum.photos/seed/pilates/600/400" },
    new Training { Id = 6, UserId = 5, Name = "Strength Training", MaxAmountOfParticipants = 16, CurrentParticipants = 11, StartDate = new DateTime(2026, 6, 6), TrainingImage = "https://picsum.photos/seed/strength/600/400" },
    new Training { Id = 7, UserId = 6, Name = "Boxing", MaxAmountOfParticipants = 14, CurrentParticipants = 9, StartDate = new DateTime(2026, 6, 7), TrainingImage = "https://picsum.photos/seed/boxing/600/400" },
    new Training { Id = 8, UserId = 6, Name = "Kickboxing", MaxAmountOfParticipants = 15, CurrentParticipants = 7, StartDate = new DateTime(2026, 6, 8), TrainingImage = "https://picsum.photos/seed/kickboxing/600/400" },
    new Training { Id = 9, UserId = 3, Name = "Morning Fitness", MaxAmountOfParticipants = 20, CurrentParticipants = 13, StartDate = new DateTime(2026, 6, 9), TrainingImage = "https://picsum.photos/seed/morningfitness/600/400" },
    new Training { Id = 10, UserId = 4, Name = "Evening Cardio", MaxAmountOfParticipants = 18, CurrentParticipants = 15, StartDate = new DateTime(2026, 6, 10), TrainingImage = "https://picsum.photos/seed/eveningcardio/600/400" },
    new Training { Id = 11, UserId = 5, Name = "Body Pump", MaxAmountOfParticipants = 17, CurrentParticipants = 10, StartDate = new DateTime(2026, 6, 11), TrainingImage = "https://picsum.photos/seed/bodypump/600/400" },
    new Training { Id = 12, UserId = 6, Name = "Functional Training", MaxAmountOfParticipants = 14, CurrentParticipants = 8, StartDate = new DateTime(2026, 6, 12), TrainingImage = "https://picsum.photos/seed/functional/600/400" },
    new Training { Id = 13, UserId = 3, Name = "Stretching", MaxAmountOfParticipants = 12, CurrentParticipants = 6, StartDate = new DateTime(2026, 6, 13), TrainingImage = "https://picsum.photos/seed/stretching/600/400" },
    new Training { Id = 14, UserId = 4, Name = "Bootcamp", MaxAmountOfParticipants = 20, CurrentParticipants = 18, StartDate = new DateTime(2026, 6, 14), TrainingImage = "https://picsum.photos/seed/bootcamp/600/400" },
    new Training { Id = 15, UserId = 5, Name = "Abs Workout", MaxAmountOfParticipants = 15, CurrentParticipants = 9, StartDate = new DateTime(2026, 6, 15), TrainingImage = "https://picsum.photos/seed/absworkout/600/400" },
    new Training { Id = 16, UserId = 6, Name = "Powerlifting", MaxAmountOfParticipants = 10, CurrentParticipants = 5, StartDate = new DateTime(2026, 6, 16), TrainingImage = "https://picsum.photos/seed/powerlifting/600/400" },
    new Training { Id = 17, UserId = 3, Name = "Zumba", MaxAmountOfParticipants = 20, CurrentParticipants = 14, StartDate = new DateTime(2026, 6, 17), TrainingImage = "https://picsum.photos/seed/zumba/600/400" },
    new Training { Id = 18, UserId = 4, Name = "Aerobics", MaxAmountOfParticipants = 18, CurrentParticipants = 12, StartDate = new DateTime(2026, 6, 18), TrainingImage = "https://picsum.photos/seed/aerobics/600/400" },
    new Training { Id = 19, UserId = 5, Name = "Circuit Training", MaxAmountOfParticipants = 16, CurrentParticipants = 11, StartDate = new DateTime(2026, 6, 19), TrainingImage = "https://picsum.photos/seed/circuit/600/400" },
    new Training { Id = 20, UserId = 6, Name = "Core Workout", MaxAmountOfParticipants = 15, CurrentParticipants = 10, StartDate = new DateTime(2026, 6, 20), TrainingImage = "https://picsum.photos/seed/core/600/400" }
);

            // ============================
            // NOTIFICATIONS (seed)
            // Admini + Radnici najčešće dodaju obavijesti
            // ============================
            modelBuilder.Entity<Notification>().HasData(
                new Notification
                {
                    Id = 1,
                    UserId = 1, // Admin
                    Title = "Obavijest",
                    Content = "Funkcionalni trening planiran za večeras je otkazan.",
                    CreatedAt = new DateTime(2026, 2, 10, 12, 0, 0)
                },
                new Notification
                {
                    Id = 2,
                    UserId = 2, // Admin
                    Title = "Obavijest",
                    Content = "Termini pilatesa za sljedeću sedmicu su Uto-Sri-Pet 17:00.",
                    CreatedAt = new DateTime(2026, 2, 12, 9, 30, 0)
                },
                new Notification
                {
                    Id = 3,
                    UserId = 7, // Radnik
                    Title = "Obavijest",
                    Content = "Podsjetnik: članarine se mogu produžiti do 25. u mjesecu.",
                    CreatedAt = new DateTime(2026, 2, 14, 15, 10, 0)
                },
                new Notification
                {
                    Id = 4,
                    UserId = 8, // Radnik
                    Title = "Obavijest",
                    Content = "U subotu radimo skraćeno: 09:00–14:00.",
                    CreatedAt = new DateTime(2026, 2, 15, 11, 0, 0)
                },
                new Notification
                {
                    Id = 5,
                    UserId = 1, // Admin
                    Title = "Obavijest",
                    Content = "Uveden je novi VIP paket članarine. Pogledajte detalje na recepciji.",
                    CreatedAt = new DateTime(2026, 2, 16, 10, 0, 0)
                },
                new Notification
                {
                    Id = 6,
                    UserId = 9, // Radnik
                    Title = "Obavijest",
                    Content = "Molimo članove da nakon treninga vraćaju opremu na mjesto.",
                    CreatedAt = new DateTime(2026, 2, 17, 18, 0, 0)
                }
            );

            // ============================
            // REVIEWS (seed)
            // Tipično ih dodaju Useri (11–20), ali može i trener (3–6)
            // ============================
            modelBuilder.Entity<Review>().HasData(
                new Review
                {
                    Id = 1,
                    UserId = 11, // User
                    Message = "Odlična teretana, čisto i uredno. Preporuka!",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 2,
                    UserId = 12, // User
                    Message = "Treninzi su super, ali bi volio više večernjih termina.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 3,
                    UserId = 13, // User
                    Message = "Osoblje je ljubazno i uvijek spremno pomoći.",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 4,
                    UserId = 14, // User
                    Message = "Dobra oprema, ponekad gužva u špici.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 5,
                    UserId = 15, // User
                    Message = "Zadovoljan sam. Treneri su stvarno profesionalni.",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 6,
                    UserId = 16, // User
                    Message = "Sve je top, jedino bi muzika mogla biti malo tiša.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 7,
                    UserId = 17, // User
                    Message = "Najbolja teretana u gradu!",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 8,
                    UserId = 18, // User
                    Message = "Sviđa mi se što je uvijek čisto i uredno.",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 9,
                    UserId = 19, // User
                    Message = "Dobro iskustvo, ali bih volio više sprava za noge.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 10,
                    UserId = 20, // User
                    Message = "Super atmosfera i odlična organizacija.",
                    StarNumber = 5
                }
            );
        }
    }
}