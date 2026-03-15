using System;
using System.Collections.Generic;
using System.Linq;
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

            var baseUsers = GetBaseUsers(
                adminHash, adminSalt,
                trenerHash, trenerSalt,
                radnikHash, radnikSalt,
                userHash, userSalt);

            // 400 dodatnih usera:
            // 300 ide u 2025
            // 100 ide u 2026
            var additionalUsers = GenerateAdditionalUsers(userHash, userSalt, 400);

            var allUsers = baseUsers.Concat(additionalUsers).ToList();

            modelBuilder.Entity<User>().HasData(allUsers);
            modelBuilder.Entity<UserRole>().HasData(GenerateUserRoles(allUsers));

            modelBuilder.Entity<Membership>().HasData(
                new Membership
                {
                    Id = 1,
                    Name = "Basic",
                    MonthlyPrice = 30m,
                    YearPrice = 300m,
                    CreatedAt = new DateTime(2025, 1, 1)
                },
                new Membership
                {
                    Id = 2,
                    Name = "Standard",
                    MonthlyPrice = 45m,
                    YearPrice = 450m,
                    CreatedAt = new DateTime(2025, 1, 1)
                },
                new Membership
                {
                    Id = 3,
                    Name = "Premium",
                    MonthlyPrice = 60m,
                    YearPrice = 600m,
                    CreatedAt = new DateTime(2025, 1, 1)
                },
                new Membership
                {
                    Id = 4,
                    Name = "VIP",
                    MonthlyPrice = 80m,
                    YearPrice = 800m,
                    CreatedAt = new DateTime(2025, 1, 1)
                }
            );

            var userCreatedDates = allUsers.ToDictionary(
                x => x.Id,
                x => x.CreatedAt ?? new DateTime(2025, 1, 1)
            );

            var membershipSeed = GenerateMembershipData(
                11,
                allUsers.Max(x => x.Id),
                userCreatedDates
            );

            modelBuilder.Entity<Member>().HasData(membershipSeed.Members);
            modelBuilder.Entity<Payment>().HasData(membershipSeed.Payments);

            // Generisani treninzi za 2025 i 2026
            var trainings = GenerateTrainings();
            modelBuilder.Entity<Training>().HasData(trainings);

            // Generisane rezervacije (preko 600)
            var reservations = GenerateReservations(
                trainings,
                11,
                allUsers.Max(x => x.Id)
            );
            modelBuilder.Entity<Reservation>().HasData(reservations);

            modelBuilder.Entity<Notification>().HasData(
                new Notification
                {
                    Id = 1,
                    UserId = 1,
                    Title = "Obavijest",
                    Content = "Funkcionalni trening planiran za večeras je otkazan.",
                    CreatedAt = new DateTime(2026, 2, 10, 12, 0, 0)
                },
                new Notification
                {
                    Id = 2,
                    UserId = 2,
                    Title = "Obavijest",
                    Content = "Termini pilatesa za sljedeću sedmicu su Uto-Sri-Pet 17:00.",
                    CreatedAt = new DateTime(2026, 2, 12, 9, 30, 0)
                },
                new Notification
                {
                    Id = 3,
                    UserId = 7,
                    Title = "Obavijest",
                    Content = "Podsjetnik: članarine se mogu produžiti do 25. u mjesecu.",
                    CreatedAt = new DateTime(2026, 2, 14, 15, 10, 0)
                },
                new Notification
                {
                    Id = 4,
                    UserId = 8,
                    Title = "Obavijest",
                    Content = "U subotu radimo skraćeno: 09:00–14:00.",
                    CreatedAt = new DateTime(2026, 2, 15, 11, 0, 0)
                },
                new Notification
                {
                    Id = 5,
                    UserId = 1,
                    Title = "Obavijest",
                    Content = "Uveden je novi VIP paket članarine. Pogledajte detalje na recepciji.",
                    CreatedAt = new DateTime(2026, 2, 16, 10, 0, 0)
                },
                new Notification
                {
                    Id = 6,
                    UserId = 9,
                    Title = "Obavijest",
                    Content = "Molimo članove da nakon treninga vraćaju opremu na mjesto.",
                    CreatedAt = new DateTime(2026, 2, 17, 18, 0, 0)
                }
            );

            modelBuilder.Entity<Review>().HasData(
                new Review
                {
                    Id = 1,
                    UserId = 11,
                    Message = "Odlična teretana, čisto i uredno. Preporuka!",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 2,
                    UserId = 12,
                    Message = "Treninzi su super, ali bi volio više večernjih termina.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 3,
                    UserId = 13,
                    Message = "Osoblje je ljubazno i uvijek spremno pomoći.",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 4,
                    UserId = 14,
                    Message = "Dobra oprema, ponekad gužva u špici.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 5,
                    UserId = 15,
                    Message = "Zadovoljan sam. Treneri su stvarno profesionalni.",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 6,
                    UserId = 16,
                    Message = "Sve je top, jedino bi muzika mogla biti malo tiša.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 7,
                    UserId = 17,
                    Message = "Najbolja teretana u gradu!",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 8,
                    UserId = 18,
                    Message = "Sviđa mi se što je uvijek čisto i uredno.",
                    StarNumber = 5
                },
                new Review
                {
                    Id = 9,
                    UserId = 19,
                    Message = "Dobro iskustvo, ali bih volio više sprava za noge.",
                    StarNumber = 4
                },
                new Review
                {
                    Id = 10,
                    UserId = 20,
                    Message = "Super atmosfera i odlična organizacija.",
                    StarNumber = 5
                }
            );

            modelBuilder.Entity<WorkerTask>().HasData(
                new WorkerTask
                {
                    Id = 1,
                    Name = "Provjera opreme",
                    Details = "Izvršiti dnevnu provjeru sprava u sali 1.",
                    CreatedTaskDate = new DateTime(2026, 2, 1),
                    "ExpirationTaskDate = new DateTime(2026, 2, 2),
                    IsFinished = false,
                    UserId = 7
                },
                new WorkerTask
                {
                    Id = 2,
                    Name = "Čišćenje svlačionice",
                    Details = "Detaljno čišćenje muške svlačionice.",
                    CreatedTaskDate = new DateTime(2026, 2, 3),
                    "ExpirationTaskDate = new DateTime(2026, 2, 3),
                    IsFinished = true,
                    UserId = 7
                },
                new WorkerTask
                {
                    Id = 3,
                    Name = "Inventura šanka",
                    Details = "Provjeriti stanje proteinskih napitaka.",
                    CreatedTaskDate = new DateTime(2026, 2, 5),
                    "ExpirationTaskDate = new DateTime(2026, 2, 6),
                    IsFinished = false,
                    UserId = 8
                },
                new WorkerTask
                {
                    Id = 4,
                    Name = "Organizacija termina",
                    Details = "Rasporediti termine za nove članove.",
                    CreatedTaskDate = new DateTime(2026, 2, 7),
                    "ExpirationTaskDate = new DateTime(2026, 2, 8),
                    IsFinished = false,
                    UserId = 8
                },
                new WorkerTask
                {
                    Id = 5,
                    Name = "Ažuriranje članova",
                    Details = "Provjeriti članarine koje ističu ove sedmice.",
                    CreatedTaskDate = new DateTime(2026, 2, 10),
                    "ExpirationTaskDate = new DateTime(2026, 2, 12),
                    IsFinished = true,
                    UserId = 9
                },
                new WorkerTask
                {
                    Id = 6,
                    Name = "Priprema sale",
                    Details = "Pripremiti salu za večernji grupni trening.",
                    CreatedTaskDate = new DateTime(2026, 2, 11),
                    "ExpirationTaskDate = new DateTime(2026, 2, 11),
                    IsFinished = false,
                    UserId = 9
                },
                new WorkerTask
                {
                    Id = 7,
                    Name = "Marketing objava",
                    Details = "Objaviti promociju na društvenim mrežama.",
                    CreatedTaskDate = new DateTime(2026, 2, 13),
                    "ExpirationTaskDate = new DateTime(2026, 2, 14),
                    IsFinished = false,
                    UserId = 10
                },
                new WorkerTask
                {
                    Id = 8,
                    Name = "Pregled rezervacija",
                    Details = "Provjeriti rezervacije za vikend termine.",
                    CreatedTaskDate = new DateTime(2026, 2, 15),
                    "ExpirationTaskDate = new DateTime(2026, 2, 16),
                    IsFinished = true,
                    UserId = 10
                }
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

        private static List<User> GetBaseUsers(
            string adminHash,
            string adminSalt,
            string trenerHash,
            string trenerSalt,
            string radnikHash,
            string radnikSalt,
            string userHash,
            string userSalt)
        {
            return new List<User>
            {
                new User
                {
                    Id = 1,
                    FirstName = "Tarik",
                    LastName = "Malic",
                    Username = "tare45",
                    Email = "healthcaretest190@gmail.com",
                    PhoneNumber = "061111111",
                    DateOfBirth = new DateTime(1995, 5, 12),
                    IsActive = true,
                    IsAdmin = true,
                    IsUser = false,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = adminHash,
                    PasswordSalt = adminSalt
                },
                new User
                {
                    Id = 2,
                    FirstName = "Amir",
                    LastName = "Ibrahimovic",
                    Username = "amir56",
                    Email = "amir@example.com",
                    PhoneNumber = "061111112",
                    DateOfBirth = new DateTime(1994, 3, 22),
                    IsActive = true,
                    IsAdmin = true,
                    IsUser = false,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = adminHash,
                    PasswordSalt = adminSalt
                },

                new User
                {
                    Id = 3,
                    FirstName = "Marko",
                    LastName = "Markovic",
                    Username = "marko78",
                    Email = "marko@example.com",
                    PhoneNumber = "061111113",
                    DateOfBirth = new DateTime(1990, 7, 14),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = true,
                    IsRadnik = false,
                    AboutMe = "Licencirani fitness trener sa 5 godina iskustva u radu sa klijentima svih uzrasta.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = trenerHash,
                    PasswordSalt = trenerSalt
                },
                new User
                {
                    Id = 4,
                    FirstName = "Ivan",
                    LastName = "Ivic",
                    Username = "ivan11",
                    Email = "ivan@example.com",
                    PhoneNumber = "061111114",
                    DateOfBirth = new DateTime(1989, 2, 10),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = true,
                    IsRadnik = false,
                    AboutMe = "Specijalizovan za kondicionu pripremu i izgradnju mišićne mase.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = trenerHash,
                    PasswordSalt = trenerSalt
                },
                new User
                {
                    Id = 5,
                    FirstName = "Petar",
                    LastName = "Petrovic",
                    Username = "petar21",
                    Email = "petar@example.com",
                    PhoneNumber = "061111115",
                    DateOfBirth = new DateTime(1992, 9, 5),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = true,
                    IsRadnik = false,
                    AboutMe = "Stručnjak za funkcionalne treninge i planove ishrane.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = trenerHash,
                    PasswordSalt = trenerSalt
                },
                new User
                {
                    Id = 6,
                    FirstName = "Luka",
                    LastName = "Lukic",
                    Username = "luka34",
                    Email = "luka@example.com",
                    PhoneNumber = "061111116",
                    DateOfBirth = new DateTime(1993, 12, 18),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = true,
                    IsRadnik = false,
                    AboutMe = "Posvećen radu sa početnicima i personalizovanim fitness programima.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = trenerHash,
                    PasswordSalt = trenerSalt
                },

                new User
                {
                    Id = 7,
                    FirstName = "Nedim",
                    LastName = "Nedimovic",
                    Username = "nedim89",
                    Email = "nedim@example.com",
                    PhoneNumber = "061111117",
                    DateOfBirth = new DateTime(1996, 4, 3),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = false,
                    IsRadnik = true,
                    AboutMe = "Zadužen za organizaciju termina i podršku članovima teretane.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = radnikHash,
                    PasswordSalt = radnikSalt
                },
                new User
                {
                    Id = 8,
                    FirstName = "Amela",
                    LastName = "Amelovic",
                    Username = "amela900",
                    Email = "amela@example.com",
                    PhoneNumber = "061111118",
                    DateOfBirth = new DateTime(1997, 8, 21),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = false,
                    IsRadnik = true,
                    AboutMe = "Brine o administraciji i svakodnevnom radu fitness centra.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = radnikHash,
                    PasswordSalt = radnikSalt
                },
                new User
                {
                    Id = 9,
                    FirstName = "Tarik",
                    LastName = "Tarikovic",
                    Username = "tarik345",
                    Email = "tarik@example.com",
                    PhoneNumber = "061111119",
                    DateOfBirth = new DateTime(1995, 11, 9),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = false,
                    IsRadnik = true,
                    AboutMe = "Odgovoran za korisničku podršku i prijem novih članova.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = radnikHash,
                    PasswordSalt = radnikSalt
                },
                new User
                {
                    Id = 10,
                    FirstName = "Emina",
                    LastName = "Eminovic",
                    Username = "emina112",
                    Email = "emina@example.com",
                    PhoneNumber = "061111120",
                    DateOfBirth = new DateTime(1998, 1, 15),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = false,
                    IsTrener = false,
                    IsRadnik = true,
                    AboutMe = "Koordinira raspored treninga i komunikaciju sa trenerima.",
                    CreatedAt = new DateTime(2025, 1, 1),
                    PasswordHash = radnikHash,
                    PasswordSalt = radnikSalt
                },

                new User
                {
                    Id = 11,
                    FirstName = "Haris",
                    LastName = "Hasic",
                    Username = "haris1",
                    Email = "korisniktestiranje264@gmail.com",
                    PhoneNumber = "061111121",
                    DateOfBirth = new DateTime(2000, 6, 6),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 1, 10),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 12,
                    FirstName = "Denis",
                    LastName = "Denisovic",
                    Username = "denis2",
                    Email = "denis2@example.com",
                    PhoneNumber = "061111122",
                    DateOfBirth = new DateTime(1999, 9, 19),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 2, 15),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 13,
                    FirstName = "Alen",
                    LastName = "Alenovic",
                    Username = "alen3",
                    Email = "alen3@example.com",
                    PhoneNumber = "061111123",
                    DateOfBirth = new DateTime(2001, 2, 2),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 3, 12),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 14,
                    FirstName = "Kenan",
                    LastName = "Kenanovic",
                    Username = "kenan4",
                    Email = "kenan4@example.com",
                    PhoneNumber = "061111124",
                    DateOfBirth = new DateTime(1998, 7, 30),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 4, 8),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 15,
                    FirstName = "Jasmin",
                    LastName = "Jasminovic",
                    Username = "jasmin5",
                    Email = "jasmin5@example.com",
                    PhoneNumber = "061111125",
                    DateOfBirth = new DateTime(1997, 3, 11),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 5, 20),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 16,
                    FirstName = "Lejla",
                    LastName = "Lejlovic",
                    Username = "lejla6",
                    Email = "lejla6@example.com",
                    PhoneNumber = "061111126",
                    DateOfBirth = new DateTime(2002, 10, 25),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 6, 5),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 17,
                    FirstName = "Sara",
                    LastName = "Saric",
                    Username = "sara7",
                    Email = "sara7@example.com",
                    PhoneNumber = "061111127",
                    DateOfBirth = new DateTime(2001, 5, 17),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 7, 18),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 18,
                    FirstName = "Amina",
                    LastName = "Aminovic",
                    Username = "amina8",
                    Email = "amina8@example.com",
                    PhoneNumber = "061111128",
                    DateOfBirth = new DateTime(1999, 12, 4),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2025, 9, 2),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 19,
                    FirstName = "Emir",
                    LastName = "Emirovic",
                    Username = "emir9",
                    Email = "emir9@example.com",
                    PhoneNumber = "061111129",
                    DateOfBirth = new DateTime(1998, 8, 8),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2026, 1, 11),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                },
                new User
                {
                    Id = 20,
                    FirstName = "Nermin",
                    LastName = "Nerminovic",
                    Username = "nermin10",
                    Email = "nermin10@example.com",
                    PhoneNumber = "061111130",
                    DateOfBirth = new DateTime(1997, 1, 27),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = new DateTime(2026, 2, 18),
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                }
            };
        }

        private static List<User> GenerateAdditionalUsers(string userHash, string userSalt, int additionalCount)
        {
            var random = new Random(20260311);
            var users = new List<User>();

            int startId = 21;
            int counter = 0;

            int users2025 = 300;
            int users2026 = Math.Max(0, additionalCount - users2025);

            for (int i = 0; i < users2025; i++)
            {
                int id = startId + counter++;

                int month = random.Next(1, 13);
                int day = random.Next(1, DateTime.DaysInMonth(2025, month) + 1);

                var createdAt = new DateTime(2025, month, day);

                users.Add(new User
                {
                    Id = id,
                    FirstName = $"User{id}",
                    LastName = $"Test{id}",
                    Username = $"user{id}",
                    Email = $"user{id}@gymify.com",
                    PhoneNumber = $"061{random.Next(100000, 999999)}",
                    DateOfBirth = new DateTime(
                        random.Next(1995, 2006),
                        random.Next(1, 13),
                        random.Next(1, 28)
                    ),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = createdAt,
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                });
            }

            for (int i = 0; i < users2026; i++)
            {
                int id = startId + counter++;

                int month = random.Next(1, 13);
                int day = random.Next(1, DateTime.DaysInMonth(2026, month) + 1);

                var createdAt = new DateTime(2026, month, day);

                users.Add(new User
                {
                    Id = id,
                    FirstName = $"User{id}",
                    LastName = $"Test{id}",
                    Username = $"user{id}",
                    Email = $"user{id}@gymify.com",
                    PhoneNumber = $"061{random.Next(100000, 999999)}",
                    DateOfBirth = new DateTime(
                        random.Next(1995, 2006),
                        random.Next(1, 13),
                        random.Next(1, 28)
                    ),
                    IsActive = true,
                    IsAdmin = false,
                    IsUser = true,
                    IsTrener = false,
                    IsRadnik = false,
                    CreatedAt = createdAt,
                    PasswordHash = userHash,
                    PasswordSalt = userSalt
                });
            }

            return users;
        }

        private static List<UserRole> GenerateUserRoles(List<User> users)
        {
            var userRoles = new List<UserRole>();
            int id = 1;

            foreach (var user in users)
            {
                if (user.IsUser == true)
                {
                    userRoles.Add(new UserRole
                    {
                        Id = id++,
                        UserId = user.Id,
                        RoleId = 1
                    });
                }

                if (user.IsAdmin == true)
                {
                    userRoles.Add(new UserRole
                    {
                        Id = id++,
                        UserId = user.Id,
                        RoleId = 2
                    });
                }

                if (user.IsTrener == true)
                {
                    userRoles.Add(new UserRole
                    {
                        Id = id++,
                        UserId = user.Id,
                        RoleId = 3
                    });
                }

                if (user.IsRadnik == true)
                {
                    userRoles.Add(new UserRole
                    {
                        Id = id++,
                        UserId = user.Id,
                        RoleId = 4
                    });
                }
            }

            return userRoles;
        }

        private static MembershipSeedBundle GenerateMembershipData(
            int startUserId,
            int endUserId,
            Dictionary<int, DateTime> userCreatedDates)
        {
            var random = new Random(20260312);

            var result = new MembershipSeedBundle();

            int memberId = 1;
            int paymentId = 1;

            for (int userId = startUserId; userId <= endUserId; userId++)
            {
                if (!userCreatedDates.ContainsKey(userId))
                    continue;

                var createdAt = userCreatedDates[userId];

                int membershipId = random.Next(1, 5);
                bool yearly = random.Next(0, 100) < 30;

                decimal amount = membershipId switch
                {
                    1 => yearly ? 300m : 30m,
                    2 => yearly ? 450m : 45m,
                    3 => yearly ? 600m : 60m,
                    4 => yearly ? 800m : 80m,
                    _ => 30m
                };

                int durationDays = yearly ? 365 : 30;

                var paymentDate = createdAt.AddDays(random.Next(0, 15));
                var expirationDate = paymentDate.AddDays(durationDays);

                result.Members.Add(new Member
                {
                    Id = memberId++,
                    UserId = userId,
                    MembershipId = membershipId,
                    PaymentDate = paymentDate,
                    ExpirationDate = expirationDate
                });

                result.Payments.Add(new Payment
                {
                    Id = paymentId++,
                    UserId = userId,
                    MembershipId = membershipId,
                    Amount = amount,
                    PaymentDate = paymentDate,
                    PaidAt = paymentDate,
                    PaymentStatus = "Paid",
                    StripePaymentIntentId = null,
                    BillingPeriod = yearly ? "yearly" : "monthly"
                });
            }

            return result;
        }

        private static List<Training> GenerateTrainings()
{
    var random = new Random(20260315);
    var trainings = new List<Training>();

    var trainerIds = new List<int> { 3, 4, 5, 6 };

    var names = new[]
    {
        "HIIT","CrossFit","Yoga Flow","Pilates","Cardio Blast",
        "Bootcamp","Boxing","Kickboxing","Strength Training",
        "Zumba","Morning Fitness","Evening Cardio",
        "Functional Training","Circuit Training","Powerlifting"
    };

    int id = 1;

    // 2025 treninzi
    for (int i = 0; i < 60; i++)
    {
        int trainerId = trainerIds[random.Next(trainerIds.Count)];
        int month = random.Next(1, 13);
        int day = random.Next(1, 25);
        int duration = random.Next(35, 61);

        var startDate = new DateTime(2025, month, day, random.Next(6, 21), 0, 0);

        trainings.Add(new Training
        {
            Id = id++,
            UserId = trainerId,
            Name = names[random.Next(names.Length)],
            DurationMinutes = duration,
            IntensityLevel = random.Next(1, 6),
            Purpose = "Fitness",
            MaxAmountOfParticipants = random.Next(10, 20),
            CurrentParticipants = 0,
            ParticipatedOfAllTime = random.Next(50, 300),
            IsParticipationCounted = true,
            StartDate = startDate,
            TrainingImage = $"https://picsum.photos/seed/training{id}/600/400"
        });
    }

    // 2026 treninzi
    for (int i = 0; i < 60; i++)
    {
        int trainerId = trainerIds[random.Next(trainerIds.Count)];
        int month = random.Next(1, 13);
        int day = random.Next(1, 25);
        int duration = random.Next(35, 61);

        var startDate = new DateTime(2026, month, day, random.Next(6, 21), 0, 0);

        trainings.Add(new Training
        {
            Id = id++,
            UserId = trainerId,
            Name = names[random.Next(names.Length)],
            DurationMinutes = duration,
            IntensityLevel = random.Next(1, 6),
            Purpose = "Fitness",
            MaxAmountOfParticipants = random.Next(10, 20),
            CurrentParticipants = 0,
            ParticipatedOfAllTime = 0,
            IsParticipationCounted = false,
            StartDate = startDate,
            TrainingImage = $"https://picsum.photos/seed/training{id}/600/400"
        });
    }

    return trainings;
}

private static List<Reservation> GenerateReservations(
    List<Training> trainings,
    int startUserId,
    int endUserId)
{
    var random = new Random(20260316);
    var reservations = new List<Reservation>();

    int id = 1;

    foreach (var training in trainings)
    {
        int maxPossible = Math.Min(training.MaxAmountOfParticipants, endUserId - startUserId + 1);
        int reservationsForTraining = random.Next(5, Math.Min(12, maxPossible + 1));

        var usedUserIds = new HashSet<int>();

        for (int i = 0; i < reservationsForTraining; i++)
        {
            int userId;
            do
            {
                userId = random.Next(startUserId, endUserId + 1);
            }
            while (!usedUserIds.Add(userId));

            reservations.Add(new Reservation
            {
                Id = id++,
                UserId = userId,
                TrainingId = training.Id,
                CreatedAt = training.StartDate.AddDays(-random.Next(1, 10)),
                Status = "Confirmed",
    CancelledAt = null,
    CancelReason = null

            });
        }

        training.CurrentParticipants = reservationsForTraining;
    }

    return reservations;
}
    }
}