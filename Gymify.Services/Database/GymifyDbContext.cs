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
        public DbSet<Reward> Rewards { get; set; }
        public DbSet<UserReward> UserRewards { get; set; }

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

    new User { Id = 1, FirstName = "Tarik", LastName = "Malic", Username = "tare45", Email = "healthcaretest190@gmail.com", PhoneNumber = "061111111", DateOfBirth = new DateTime(1995, 5, 12), IsActive = true, IsAdmin = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = adminHash, PasswordSalt = adminSalt },
    new User { Id = 2, FirstName = "Amir", LastName = "Ibrahimovic", Username = "amir56", Email = "amir@example.com", PhoneNumber = "061111112", DateOfBirth = new DateTime(1994, 3, 22), IsActive = true, IsAdmin = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = adminHash, PasswordSalt = adminSalt },

    new User { Id = 3, FirstName = "Marko", LastName = "Markovic", Username = "marko78", Email = "marko@example.com", PhoneNumber = "061111113", DateOfBirth = new DateTime(1990, 7, 14), IsActive = true, IsTrener = true, AboutMe = "Licencirani fitness trener sa 5 godina iskustva u radu sa klijentima svih uzrasta.", CreatedAt = new DateTime(2024,1,1), PasswordHash = trenerHash, PasswordSalt = trenerSalt },
    new User { Id = 4, FirstName = "Ivan", LastName = "Ivic", Username = "ivan11", Email = "ivan@example.com", PhoneNumber = "061111114", DateOfBirth = new DateTime(1989, 2, 10), IsActive = true, IsTrener = true, AboutMe = "Specijalizovan za kondicionu pripremu i izgradnju mišićne mase.", CreatedAt = new DateTime(2024,1,1), PasswordHash = trenerHash, PasswordSalt = trenerSalt },
    new User { Id = 5, FirstName = "Petar", LastName = "Petrovic", Username = "petar21", Email = "petar@example.com", PhoneNumber = "061111115", DateOfBirth = new DateTime(1992, 9, 5), IsActive = true, IsTrener = true, AboutMe = "Stručnjak za funkcionalne treninge i planove ishrane.", CreatedAt = new DateTime(2024,1,1), PasswordHash = trenerHash, PasswordSalt = trenerSalt },
    new User { Id = 6, FirstName = "Luka", LastName = "Lukic", Username = "luka34", Email = "luka@example.com", PhoneNumber = "061111116", DateOfBirth = new DateTime(1993, 12, 18), IsActive = true, IsTrener = true, AboutMe = "Posvećen radu sa početnicima i personalizovanim fitness programima.", CreatedAt = new DateTime(2024,1,1), PasswordHash = trenerHash, PasswordSalt = trenerSalt },

    new User { Id = 7, FirstName = "Nedim", LastName = "Nedimovic", Username = "nedim89", Email = "nedim@example.com", PhoneNumber = "061111117", DateOfBirth = new DateTime(1996, 4, 3), IsActive = true, IsRadnik = true, AboutMe = "Zadužen za organizaciju termina i podršku članovima teretane.", CreatedAt = new DateTime(2024,1,1), PasswordHash = radnikHash, PasswordSalt = radnikSalt },
    new User { Id = 8, FirstName = "Amela", LastName = "Amelovic", Username = "amela900", Email = "amela@example.com", PhoneNumber = "061111118", DateOfBirth = new DateTime(1997, 8, 21), IsActive = true, IsRadnik = true, AboutMe = "Brine o administraciji i svakodnevnom radu fitness centra.", CreatedAt = new DateTime(2024,1,1), PasswordHash = radnikHash, PasswordSalt = radnikSalt },
    new User { Id = 9, FirstName = "Tarik", LastName = "Tarikovic", Username = "tarik345", Email = "tarik@example.com", PhoneNumber = "061111119", DateOfBirth = new DateTime(1995, 11, 9), IsActive = true, IsRadnik = true, AboutMe = "Odgovoran za korisničku podršku i prijem novih članova.", CreatedAt = new DateTime(2024,1,1), PasswordHash = radnikHash, PasswordSalt = radnikSalt },
    new User { Id = 10, FirstName = "Emina", LastName = "Eminovic", Username = "emina112", Email = "emina@example.com", PhoneNumber = "061111120", DateOfBirth = new DateTime(1998, 1, 15), IsActive = true, IsRadnik = true, AboutMe = "Koordinira raspored treninga i komunikaciju sa trenerima.", CreatedAt = new DateTime(2024,1,1), PasswordHash = radnikHash, PasswordSalt = radnikSalt },

    new User { Id = 11, FirstName = "Haris", LastName = "Hasic", Username = "haris1", Email = "korisniktestiranje264@gmail.com", PhoneNumber = "061111121", DateOfBirth = new DateTime(2000, 6, 6), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 12, FirstName = "Denis", LastName = "Denisovic", Username = "denis2", Email = "denis2@example.com", PhoneNumber = "061111122", DateOfBirth = new DateTime(1999, 9, 19), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 13, FirstName = "Alen", LastName = "Alenovic", Username = "alen3", Email = "alen3@example.com", PhoneNumber = "061111123", DateOfBirth = new DateTime(2001, 2, 2), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 14, FirstName = "Kenan", LastName = "Kenanovic", Username = "kenan4", Email = "kenan4@example.com", PhoneNumber = "061111124", DateOfBirth = new DateTime(1998, 7, 30), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 15, FirstName = "Jasmin", LastName = "Jasminovic", Username = "jasmin5", Email = "jasmin5@example.com", PhoneNumber = "061111125", DateOfBirth = new DateTime(1997, 3, 11), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 16, FirstName = "Lejla", LastName = "Lejlovic", Username = "lejla6", Email = "lejla6@example.com", PhoneNumber = "061111126", DateOfBirth = new DateTime(2002, 10, 25), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 17, FirstName = "Sara", LastName = "Saric", Username = "sara7", Email = "sara7@example.com", PhoneNumber = "061111127", DateOfBirth = new DateTime(2001, 5, 17), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 18, FirstName = "Amina", LastName = "Aminovic", Username = "amina8", Email = "amina8@example.com", PhoneNumber = "061111128", DateOfBirth = new DateTime(1999, 12, 4), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 19, FirstName = "Emir", LastName = "Emirovic", Username = "emir9", Email = "emir9@example.com", PhoneNumber = "061111129", DateOfBirth = new DateTime(1998, 8, 8), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt },
    new User { Id = 20, FirstName = "Nermin", LastName = "Nerminovic", Username = "nermin10", Email = "nermin10@example.com", PhoneNumber = "061111130", DateOfBirth = new DateTime(1997, 1, 27), IsActive = true, IsUser = true, CreatedAt = new DateTime(2024,1,1), PasswordHash = userHash, PasswordSalt = userSalt }
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
                new UserRole { Id = 10, UserId = 10, RoleId = 4 },

                new UserRole { Id = 11, UserId = 11, RoleId = 1 },
                new UserRole { Id = 12, UserId = 12, RoleId = 1 },
                new UserRole { Id = 13, UserId = 13, RoleId = 1 },
                new UserRole { Id = 14, UserId = 14, RoleId = 1 },
                new UserRole { Id = 15, UserId = 15, RoleId = 1 },
                new UserRole { Id = 16, UserId = 16, RoleId = 1 },
                new UserRole { Id = 17, UserId = 17, RoleId = 1 },
                new UserRole { Id = 18, UserId = 18, RoleId = 1 },
                new UserRole { Id = 19, UserId = 19, RoleId = 1 },
                new UserRole { Id = 20, UserId = 20, RoleId = 1 }
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
                new Member { Id = 1, UserId = 11, MembershipId = 2, PaymentDate = DateTime.UtcNow, ExpirationDate = DateTime.UtcNow.AddDays(-3)},
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
    new Training { Id = 1, UserId = 3, Name = "HIIT", MaxAmountOfParticipants = 15, CurrentParticipants = 10, ParicipatedOfAllTime = 120, StartDate = new DateTime(2026, 6, 1), TrainingImage = "https://picsum.photos/seed/hiit/600/400" },
    new Training { Id = 2, UserId = 3, Name = "Cardio Blast", MaxAmountOfParticipants = 20, CurrentParticipants = 12, ParicipatedOfAllTime = 185, StartDate = new DateTime(2026, 6, 2), TrainingImage = "https://picsum.photos/seed/cardioblast/600/400" },
    new Training { Id = 3, UserId = 4, Name = "CrossFit", MaxAmountOfParticipants = 18, CurrentParticipants = 14, ParicipatedOfAllTime = 240, StartDate = new DateTime(2026, 6, 3), TrainingImage = "https://picsum.photos/seed/crossfit/600/400" },
    new Training { Id = 4, UserId = 4, Name = "Yoga Flow", MaxAmountOfParticipants = 12, CurrentParticipants = 8, ParicipatedOfAllTime = 95, StartDate = new DateTime(2026, 6, 4), TrainingImage = "https://picsum.photos/seed/yogaflow/600/400" },
    new Training { Id = 5, UserId = 5, Name = "Pilates", MaxAmountOfParticipants = 10, CurrentParticipants = 6, ParicipatedOfAllTime = 80, StartDate = new DateTime(2026, 6, 5), TrainingImage = "https://picsum.photos/seed/pilates/600/400" },
    new Training { Id = 6, UserId = 5, Name = "Strength Training", MaxAmountOfParticipants = 16, CurrentParticipants = 11, ParicipatedOfAllTime = 210, StartDate = new DateTime(2026, 6, 6), TrainingImage = "https://picsum.photos/seed/strength/600/400" },
    new Training { Id = 7, UserId = 6, Name = "Boxing", MaxAmountOfParticipants = 14, CurrentParticipants = 9, ParicipatedOfAllTime = 160, StartDate = new DateTime(2026, 6, 7), TrainingImage = "https://picsum.photos/seed/boxing/600/400" },
    new Training { Id = 8, UserId = 6, Name = "Kickboxing", MaxAmountOfParticipants = 15, CurrentParticipants = 7, ParicipatedOfAllTime = 140, StartDate = new DateTime(2026, 6, 8), TrainingImage = "https://picsum.photos/seed/kickboxing/600/400" },
    new Training { Id = 9, UserId = 3, Name = "Morning Fitness", MaxAmountOfParticipants = 20, CurrentParticipants = 13, ParicipatedOfAllTime = 175, StartDate = new DateTime(2026, 6, 9), TrainingImage = "https://picsum.photos/seed/morningfitness/600/400" },
    new Training { Id = 10, UserId = 4, Name = "Evening Cardio", MaxAmountOfParticipants = 18, CurrentParticipants = 15, ParicipatedOfAllTime = 190, StartDate = new DateTime(2026, 6, 10), TrainingImage = "https://picsum.photos/seed/eveningcardio/600/400" },
    new Training { Id = 11, UserId = 5, Name = "Body Pump", MaxAmountOfParticipants = 17, CurrentParticipants = 10, ParicipatedOfAllTime = 155, StartDate = new DateTime(2026, 6, 11), TrainingImage = "https://picsum.photos/seed/bodypump/600/400" },
    new Training { Id = 12, UserId = 6, Name = "Functional Training", MaxAmountOfParticipants = 14, CurrentParticipants = 8, ParicipatedOfAllTime = 130, StartDate = new DateTime(2026, 6, 12), TrainingImage = "https://picsum.photos/seed/functional/600/400" },
    new Training { Id = 13, UserId = 3, Name = "Stretching", MaxAmountOfParticipants = 12, CurrentParticipants = 6, ParicipatedOfAllTime = 70, StartDate = new DateTime(2026, 6, 13), TrainingImage = "https://picsum.photos/seed/stretching/600/400" },
    new Training { Id = 14, UserId = 4, Name = "Bootcamp", MaxAmountOfParticipants = 20, CurrentParticipants = 18, ParicipatedOfAllTime = 260, StartDate = new DateTime(2026, 6, 14), TrainingImage = "https://picsum.photos/seed/bootcamp/600/400" },
    new Training { Id = 15, UserId = 5, Name = "Abs Workout", MaxAmountOfParticipants = 15, CurrentParticipants = 9, ParicipatedOfAllTime = 145, StartDate = new DateTime(2026, 6, 15), TrainingImage = "https://picsum.photos/seed/absworkout/600/400" },
    new Training { Id = 16, UserId = 6, Name = "Powerlifting", MaxAmountOfParticipants = 10, CurrentParticipants = 5, ParicipatedOfAllTime = 110, StartDate = new DateTime(2026, 6, 16), TrainingImage = "https://picsum.photos/seed/powerlifting/600/400" },
    new Training { Id = 17, UserId = 3, Name = "Zumba", MaxAmountOfParticipants = 20, CurrentParticipants = 14, ParicipatedOfAllTime = 220, StartDate = new DateTime(2026, 6, 17), TrainingImage = "https://picsum.photos/seed/zumba/600/400" },
    new Training { Id = 18, UserId = 4, Name = "Aerobics", MaxAmountOfParticipants = 18, CurrentParticipants = 12, ParicipatedOfAllTime = 165, StartDate = new DateTime(2026, 6, 18), TrainingImage = "https://picsum.photos/seed/aerobics/600/400" },
    new Training { Id = 19, UserId = 5, Name = "Circuit Training", MaxAmountOfParticipants = 16, CurrentParticipants = 11, ParicipatedOfAllTime = 180, StartDate = new DateTime(2026, 6, 19), TrainingImage = "https://picsum.photos/seed/circuit/600/400" },
    new Training { Id = 20, UserId = 6, Name = "Core Workout", MaxAmountOfParticipants = 15, CurrentParticipants = 10, ParicipatedOfAllTime = 150, StartDate = new DateTime(2026, 6, 20), TrainingImage = "https://picsum.photos/seed/core/600/400" }
);

modelBuilder.Entity<Training>().HasData(
    new Training
    {
        Id = 21,
        UserId = 3, // trener Marko
        Name = "HIIT (Feb)",
        MaxAmountOfParticipants = 15,
        CurrentParticipants = 11,
        StartDate = new DateTime(2026, 2, 10, 18, 0, 0),
        TrainingImage = "https://picsum.photos/seed/hiitfeb/600/400"
    },
    new Training
    {
        Id = 22,
        UserId = 4, // trener Ivan
        Name = "Yoga Flow (Feb)",
        MaxAmountOfParticipants = 12,
        CurrentParticipants = 9,
        StartDate = new DateTime(2026, 2, 14, 19, 30, 0),
        TrainingImage = "https://picsum.photos/seed/yogafeb/600/400"
    },
    new Training
    {
        Id = 23,
        UserId = 5, // trener Petar
        Name = "Strength Training (Feb)",
        MaxAmountOfParticipants = 16,
        CurrentParticipants = 13,
        StartDate = new DateTime(2026, 2, 20, 17, 0, 0),
        TrainingImage = "https://picsum.photos/seed/strengthfeb/600/400"
    },
    new Training
    {
        Id = 24,
        UserId = 6, // trener Luka
        Name = "Boxing (Feb)",
        MaxAmountOfParticipants = 14,
        CurrentParticipants = 10,
        StartDate = new DateTime(2026, 2, 25, 20, 0, 0),
        TrainingImage = "https://picsum.photos/seed/boxingfeb/600/400"
    }
);

modelBuilder.Entity<Reservation>().HasData(
    // postojeće (1-4) ostaju kako jesu...

    // ===== JUN treninzi (Id 1 - 20) =====
    new Reservation { Id = 5,  UserId = 12, TrainingId = 1,  CreatedAt = new DateTime(2026, 5, 25, 10, 0, 0) },
    new Reservation { Id = 6,  UserId = 13, TrainingId = 1,  CreatedAt = new DateTime(2026, 5, 26, 11, 30, 0) },
    new Reservation { Id = 7,  UserId = 14, TrainingId = 2,  CreatedAt = new DateTime(2026, 5, 27, 9, 15, 0) },
    new Reservation { Id = 8,  UserId = 15, TrainingId = 2,  CreatedAt = new DateTime(2026, 5, 28, 14, 45, 0) },

    new Reservation { Id = 9,  UserId = 16, TrainingId = 3,  CreatedAt = new DateTime(2026, 5, 29, 16, 0, 0) },
    new Reservation { Id = 10, UserId = 17, TrainingId = 3,  CreatedAt = new DateTime(2026, 5, 30, 18, 20, 0) },
    new Reservation { Id = 11, UserId = 18, TrainingId = 4,  CreatedAt = new DateTime(2026, 5, 31, 12, 10, 0) },
    new Reservation { Id = 12, UserId = 19, TrainingId = 4,  CreatedAt = new DateTime(2026, 6,  1, 8,  5, 0) },

    new Reservation { Id = 13, UserId = 20, TrainingId = 5,  CreatedAt = new DateTime(2026, 6,  2, 13, 0, 0) },
    new Reservation { Id = 14, UserId = 12, TrainingId = 6,  CreatedAt = new DateTime(2026, 6,  3, 15, 25, 0) },
    new Reservation { Id = 15, UserId = 13, TrainingId = 7,  CreatedAt = new DateTime(2026, 6,  4, 17, 40, 0) },
    new Reservation { Id = 16, UserId = 14, TrainingId = 8,  CreatedAt = new DateTime(2026, 6,  5, 19, 10, 0) },

    new Reservation { Id = 17, UserId = 15, TrainingId = 9,  CreatedAt = new DateTime(2026, 6,  6, 10, 30, 0) },
    new Reservation { Id = 18, UserId = 16, TrainingId = 10, CreatedAt = new DateTime(2026, 6,  7, 11, 45, 0) },
    new Reservation { Id = 19, UserId = 17, TrainingId = 11, CreatedAt = new DateTime(2026, 6,  8, 9,  0, 0) },
    new Reservation { Id = 20, UserId = 18, TrainingId = 12, CreatedAt = new DateTime(2026, 6,  9, 12, 20, 0) },

    new Reservation { Id = 21, UserId = 19, TrainingId = 13, CreatedAt = new DateTime(2026, 6, 10, 14, 0, 0) },
    new Reservation { Id = 22, UserId = 20, TrainingId = 14, CreatedAt = new DateTime(2026, 6, 11, 16, 30, 0) },
    new Reservation { Id = 23, UserId = 12, TrainingId = 15, CreatedAt = new DateTime(2026, 6, 12, 18, 0, 0) },
    new Reservation { Id = 24, UserId = 13, TrainingId = 16, CreatedAt = new DateTime(2026, 6, 13, 20, 10, 0) },

    new Reservation { Id = 25, UserId = 14, TrainingId = 17, CreatedAt = new DateTime(2026, 6, 14, 9,  15, 0) },
    new Reservation { Id = 26, UserId = 15, TrainingId = 18, CreatedAt = new DateTime(2026, 6, 15, 11, 0, 0) },
    new Reservation { Id = 27, UserId = 16, TrainingId = 19, CreatedAt = new DateTime(2026, 6, 16, 13, 40, 0) },
    new Reservation { Id = 28, UserId = 17, TrainingId = 20, CreatedAt = new DateTime(2026, 6, 17, 15, 55, 0) },

    // ===== FEB treninzi (Id 21 - 24) dodatne rezervacije =====
    new Reservation { Id = 29, UserId = 12, TrainingId = 21, CreatedAt = new DateTime(2026, 2, 8,  10, 0, 0) },
    new Reservation { Id = 30, UserId = 13, TrainingId = 22, CreatedAt = new DateTime(2026, 2, 12, 11, 20, 0) },
    new Reservation { Id = 31, UserId = 14, TrainingId = 23, CreatedAt = new DateTime(2026, 2, 18, 9,  45, 0) },
    new Reservation { Id = 32, UserId = 15, TrainingId = 24, CreatedAt = new DateTime(2026, 2, 22, 14, 10, 0) },

    // Training 1 (HIIT - 2026-06-01)
    new Reservation { Id = 33, UserId = 16, TrainingId = 1, CreatedAt = new DateTime(2026, 5, 27, 10, 0, 0) },
    new Reservation { Id = 34, UserId = 17, TrainingId = 1, CreatedAt = new DateTime(2026, 5, 27, 10, 30, 0) },
    new Reservation { Id = 35, UserId = 18, TrainingId = 1, CreatedAt = new DateTime(2026, 5, 28, 11, 0, 0) },

    // Training 2 (Cardio Blast - 2026-06-02)
    new Reservation { Id = 36, UserId = 19, TrainingId = 2, CreatedAt = new DateTime(2026, 5, 28, 12, 0, 0) },
    new Reservation { Id = 37, UserId = 20, TrainingId = 2, CreatedAt = new DateTime(2026, 5, 29, 9, 15, 0) },
    new Reservation { Id = 38, UserId = 11, TrainingId = 2, CreatedAt = new DateTime(2026, 5, 29, 13, 40, 0) },

    // Training 3 (CrossFit - 2026-06-03)
    new Reservation { Id = 39, UserId = 12, TrainingId = 3, CreatedAt = new DateTime(2026, 5, 30, 8, 45, 0) },
    new Reservation { Id = 40, UserId = 15, TrainingId = 3, CreatedAt = new DateTime(2026, 5, 30, 12, 10, 0) },
    new Reservation { Id = 41, UserId = 20, TrainingId = 3, CreatedAt = new DateTime(2026, 5, 31, 17, 5, 0) },

    // Training 4 (Yoga Flow - 2026-06-04)
    new Reservation { Id = 42, UserId = 11, TrainingId = 4, CreatedAt = new DateTime(2026, 6, 1, 9, 0, 0) },
    new Reservation { Id = 43, UserId = 12, TrainingId = 4, CreatedAt = new DateTime(2026, 6, 1, 10, 20, 0) },
    new Reservation { Id = 44, UserId = 13, TrainingId = 4, CreatedAt = new DateTime(2026, 6, 2, 14, 0, 0) },

    // Training 5 (Pilates - 2026-06-05)
    new Reservation { Id = 45, UserId = 14, TrainingId = 5, CreatedAt = new DateTime(2026, 6, 2, 16, 30, 0) },
    new Reservation { Id = 46, UserId = 17, TrainingId = 5, CreatedAt = new DateTime(2026, 6, 3, 11, 15, 0) },

    // Training 6 (Strength Training - 2026-06-06)
    new Reservation { Id = 47, UserId = 18, TrainingId = 6, CreatedAt = new DateTime(2026, 6, 3, 9, 50, 0) },
    new Reservation { Id = 48, UserId = 19, TrainingId = 6, CreatedAt = new DateTime(2026, 6, 3, 18, 0, 0) },
    new Reservation { Id = 49, UserId = 20, TrainingId = 6, CreatedAt = new DateTime(2026, 6, 4, 12, 45, 0) },

    // Training 7 (Boxing - 2026-06-07)
    new Reservation { Id = 50, UserId = 11, TrainingId = 7, CreatedAt = new DateTime(2026, 6, 4, 14, 10, 0) },
    new Reservation { Id = 51, UserId = 12, TrainingId = 7, CreatedAt = new DateTime(2026, 6, 5, 9, 5, 0) },

    // Training 8 (Kickboxing - 2026-06-08)
    new Reservation { Id = 52, UserId = 13, TrainingId = 8, CreatedAt = new DateTime(2026, 6, 5, 10, 0, 0) },
    new Reservation { Id = 53, UserId = 14, TrainingId = 8, CreatedAt = new DateTime(2026, 6, 5, 12, 30, 0) },

    // Training 9 (Morning Fitness - 2026-06-09)
    new Reservation { Id = 54, UserId = 18, TrainingId = 9, CreatedAt = new DateTime(2026, 6, 6, 8, 0, 0) },
    new Reservation { Id = 55, UserId = 19, TrainingId = 9, CreatedAt = new DateTime(2026, 6, 6, 9, 25, 0) },
    new Reservation { Id = 56, UserId = 20, TrainingId = 9, CreatedAt = new DateTime(2026, 6, 6, 11, 40, 0) },

    // Training 10 (Evening Cardio - 2026-06-10)
    new Reservation { Id = 57, UserId = 11, TrainingId = 10, CreatedAt = new DateTime(2026, 6, 7, 10, 10, 0) },
    new Reservation { Id = 58, UserId = 12, TrainingId = 10, CreatedAt = new DateTime(2026, 6, 7, 13, 0, 0) },

    // Training 11 (Body Pump - 2026-06-11)
    new Reservation { Id = 59, UserId = 13, TrainingId = 11, CreatedAt = new DateTime(2026, 6, 8, 12, 0, 0) },
    new Reservation { Id = 60, UserId = 16, TrainingId = 11, CreatedAt = new DateTime(2026, 6, 8, 15, 30, 0) },
    new Reservation { Id = 61, UserId = 19, TrainingId = 11, CreatedAt = new DateTime(2026, 6, 9, 9, 45, 0) },

    // Training 12 (Functional Training - 2026-06-12)
    new Reservation { Id = 62, UserId = 14, TrainingId = 12, CreatedAt = new DateTime(2026, 6, 9, 10, 30, 0) },
    new Reservation { Id = 63, UserId = 15, TrainingId = 12, CreatedAt = new DateTime(2026, 6, 9, 14, 20, 0) },

    // Training 14 (Bootcamp - 2026-06-14)
    new Reservation { Id = 64, UserId = 16, TrainingId = 14, CreatedAt = new DateTime(2026, 6, 10, 9, 0, 0) },
    new Reservation { Id = 65, UserId = 17, TrainingId = 14, CreatedAt = new DateTime(2026, 6, 10, 10, 15, 0) },
    new Reservation { Id = 66, UserId = 18, TrainingId = 14, CreatedAt = new DateTime(2026, 6, 11, 12, 0, 0) },

    // Training 17 (Zumba - 2026-06-17)
    new Reservation { Id = 67, UserId = 11, TrainingId = 17, CreatedAt = new DateTime(2026, 6, 12, 11, 0, 0) },
    new Reservation { Id = 68, UserId = 12, TrainingId = 17, CreatedAt = new DateTime(2026, 6, 12, 12, 30, 0) },
    new Reservation { Id = 69, UserId = 13, TrainingId = 17, CreatedAt = new DateTime(2026, 6, 13, 9, 45, 0) },

    // Training 20 (Core Workout - 2026-06-20)
    new Reservation { Id = 70, UserId = 18, TrainingId = 20, CreatedAt = new DateTime(2026, 6, 14, 15, 0, 0) }
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

            modelBuilder.Entity<WorkerTask>().HasData(

// Nedim (7)
new WorkerTask
{
    Id = 1,
    Name = "Provjera opreme",
    Details = "Izvršiti dnevnu provjeru sprava u sali 1.",
    CreatedTaskDate = new DateTime(2026, 2, 1),
    ExparationTaskDate = new DateTime(2026, 2, 2),
    IsFinished = false,
    UserId = 7
},
new WorkerTask
{
    Id = 2,
    Name = "Čišćenje svlačionice",
    Details = "Detaljno čišćenje muške svlačionice.",
    CreatedTaskDate = new DateTime(2026, 2, 3),
    ExparationTaskDate = new DateTime(2026, 2, 3),
    IsFinished = true,
    UserId = 7
},

// Amela (8)
new WorkerTask
{
    Id = 3,
    Name = "Inventura šanka",
    Details = "Provjeriti stanje proteinskih napitaka.",
    CreatedTaskDate = new DateTime(2026, 2, 5),
    ExparationTaskDate = new DateTime(2026, 2, 6),
    IsFinished = false,
    UserId = 8
},
new WorkerTask
{
    Id = 4,
    Name = "Organizacija termina",
    Details = "Rasporediti termine za nove članove.",
    CreatedTaskDate = new DateTime(2026, 2, 7),
    ExparationTaskDate = new DateTime(2026, 2, 8),
    IsFinished = false,
    UserId = 8
},

// Tarik (9)
new WorkerTask
{
    Id = 5,
    Name = "Ažuriranje članova",
    Details = "Provjeriti članarine koje ističu ove sedmice.",
    CreatedTaskDate = new DateTime(2026, 2, 10),
    ExparationTaskDate = new DateTime(2026, 2, 12),
    IsFinished = true,
    UserId = 9
},
new WorkerTask
{
    Id = 6,
    Name = "Priprema sale",
    Details = "Pripremiti salu za večernji grupni trening.",
    CreatedTaskDate = new DateTime(2026, 2, 11),
    ExparationTaskDate = new DateTime(2026, 2, 11),
    IsFinished = false,
    UserId = 9
},

// Emina (10)
new WorkerTask
{
    Id = 7,
    Name = "Marketing objava",
    Details = "Objaviti promociju na društvenim mrežama.",
    CreatedTaskDate = new DateTime(2026, 2, 13),
    ExparationTaskDate = new DateTime(2026, 2, 14),
    IsFinished = false,
    UserId = 10
},
new WorkerTask
{
    Id = 8,
    Name = "Pregled rezervacija",
    Details = "Provjeriti rezervacije za vikend termine.",
    CreatedTaskDate = new DateTime(2026, 2, 15),
    ExparationTaskDate = new DateTime(2026, 2, 16),
    IsFinished = true,
    UserId = 10
}
);

modelBuilder.Entity<Payment>().HasData(
    new Payment { Id = 1, UserId = 11, MembershipId = 2, Amount = 45.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 2, UserId = 12, MembershipId = 2, Amount = 45.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 3, UserId = 13, MembershipId = 3, Amount = 60.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 4, UserId = 14, MembershipId = 4, Amount = 80.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 5, UserId = 15, MembershipId = 1, Amount = 30.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 6, UserId = 16, MembershipId = 2, Amount = 45.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 7, UserId = 17, MembershipId = 3, Amount = 60.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 8, UserId = 18, MembershipId = 4, Amount = 80.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 9, UserId = 19, MembershipId = 1, Amount = 30.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null },
    new Payment { Id = 10, UserId = 20, MembershipId = 2, Amount = 45.00, PaymentDate = new DateTime(2026, 2, 1), PaymentStatus = "Paid", PaidAt = new DateTime(2026, 2, 1), StripePaymentIntentId = null }
);

modelBuilder.Entity<Reward>().HasData(
        new Reward
        {
            Id = 1,
            Name = "Besplatan proteinski shake",
            Description = "Dobij besplatan proteinski shake u gym baru.",
            RequiredPoints = 100,
            IsActive = true
        },
        new Reward
        {
            Id = 2,
            Name = "1 dan besplatne članarine",
            Description = "Jedan dan besplatnog treninga.",
            RequiredPoints = 250,
            IsActive = true
        },
        new Reward
        {
            Id = 3,
            Name = "Personalni trening - 30 min",
            Description = "Besplatan personalni trening u trajanju 30 minuta.",
            RequiredPoints = 500,
            IsActive = true
        },
        new Reward
        {
            Id = 4,
            Name = "20% popusta na članarinu",
            Description = "Popust od 20% na narednu članarinu.",
            RequiredPoints = 750,
            IsActive = true
        },
        new Reward
        {
            Id = 5,
            Name = "Gymify premium majica",
            Description = "Ekskluzivna Gymify majica.",
            RequiredPoints = 1000,
            IsActive = true
        }
    );

    modelBuilder.Entity<LoyaltyPoint>().HasData(
        new LoyaltyPoint
        {
            Id = 1,
            UserId = 11, 
            TotalPoints = 120
        },
        new LoyaltyPoint
        {
            Id = 2,
            UserId = 12,
            TotalPoints = 350
        },
        new LoyaltyPoint
        {
            Id = 3,
            UserId = 13,
            TotalPoints = 780
        }
    );

        }
    }
}