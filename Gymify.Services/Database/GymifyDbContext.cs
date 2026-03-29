using System;
using System.Collections.Generic;
using System.Linq;
using Gymify.Model;
using Gymify.Services.Helpers;
using Gymify.Services.Seed;
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

        private static readonly string[] FirstNames =
        {
            "Haris", "Amar", "Kenan", "Nermin", "Adnan", "Emir", "Denis",
            "Alen", "Mahir", "Anel", "Samir", "Jasmin", "Nedim", "Damir",
            "Eldar", "Mirza", "Husein", "Selmir", "Armin", "Ismar",
            "Faruk", "Edin", "Sead", "Zlatan", "Irfan", "Vedad",
            "Emina", "Amina", "Lejla", "Sara", "Adna", "Amila", "Azra",
            "Lamija", "Selma", "Mirela", "Sanela", "Jasmina", "Arijana",
            "Dina", "Elma", "Medina", "Belma", "Nermina", "Ilma",
            "Hana", "Naida", "Melisa", "Anisa", "Sabina", "Alma"
        };

        private static readonly string[] LastNames =
        {
            "Hodzic", "Kovacevic", "Basic", "Halilovic", "Memic",
            "Delic", "Smajic", "Hadzic", "Imamovic", "Dedic",
            "Jahic", "Zukic", "Alic", "Sehic", "Mujic",
            "Kadic", "Ibric", "Avdic", "Terzic", "Begovic",
            "Sabanovic", "Mesic", "Kurtovic", "Latic", "Salihovic",
            "Turkovic", "Brankovic", "Maric", "Jovic", "Radic"
        };

        private static readonly List<TrainingSeedBundle> TrainingSeedItems = new()
        {
            new() { Name = "Power Forge", Purpose = "Strength" },
            new() { Name = "Iron Core", Purpose = "Strength" },
            new() { Name = "Muscle Pulse", Purpose = "Strength" },
            new() { Name = "Heavy Lift Lab", Purpose = "Strength" },
            new() { Name = "Strength Zone", Purpose = "Strength" },
            new() { Name = "Titan Force", Purpose = "Strength" },
            new() { Name = "Barbell Basics", Purpose = "Strength" },
            new() { Name = "Steel Motion", Purpose = "Strength" },
            new() { Name = "Upper Body Burn", Purpose = "Strength" },
            new() { Name = "Lower Body Power", Purpose = "Strength" },
            new() { Name = "Core Crusher", Purpose = "Strength" },
            new() { Name = "Strength Builder", Purpose = "Strength" },
            new() { Name = "Mass Gain Session", Purpose = "Strength" },
            new() { Name = "Explosive Power", Purpose = "Strength" },
            new() { Name = "Strong Start", Purpose = "Strength" },
            new() { Name = "Total Strength", Purpose = "Strength" },
            new() { Name = "Functional Power", Purpose = "Strength" },
            new() { Name = "Lift and Drive", Purpose = "Strength" },
            new() { Name = "Peak Force", Purpose = "Strength" },
            new() { Name = "Strength Fusion", Purpose = "Strength" },
            new() { Name = "Power Circuit X", Purpose = "Strength" },
            new() { Name = "Muscle Mechanics", Purpose = "Strength" },
            new() { Name = "Body Armor", Purpose = "Strength" },
            new() { Name = "Rep Revolution", Purpose = "Strength" },
            new() { Name = "Forge Fitness", Purpose = "Strength" },
            new() { Name = "Bench and Burn", Purpose = "Strength" },
            new() { Name = "Deadlift Dynamics", Purpose = "Strength" },
            new() { Name = "Strength Reloaded", Purpose = "Strength" },
            new() { Name = "Power Pulse Pro", Purpose = "Strength" },
            new() { Name = "Elite Strength Camp", Purpose = "Strength" },
            new() { Name = "Bodyweight Strength", Purpose = "Strength" },
            new() { Name = "Dumbbell Domination", Purpose = "Strength" },
            new() { Name = "Strongline Session", Purpose = "Strength" },
            new() { Name = "Force Factory", Purpose = "Strength" },
            new() { Name = "Solid Core Strength", Purpose = "Strength" },
            new() { Name = "Dynamic Strength", Purpose = "Strength" },
            new() { Name = "Power Hour Max", Purpose = "Strength" },
            new() { Name = "Strength Matrix", Purpose = "Strength" },
            new() { Name = "Lift Lab 360", Purpose = "Strength" },
            new() { Name = "Engineered Strength", Purpose = "Strength" },

            new() { Name = "Slim Start", Purpose = "WeightLoss" },
            new() { Name = "Burn Zone", Purpose = "WeightLoss" },
            new() { Name = "Fat Melt Express", Purpose = "WeightLoss" },
            new() { Name = "Lean Motion", Purpose = "WeightLoss" },
            new() { Name = "Shred Session", Purpose = "WeightLoss" },
            new() { Name = "Weight Loss Blast", Purpose = "WeightLoss" },
            new() { Name = "Calorie Crusher", Purpose = "WeightLoss" },
            new() { Name = "Sweat Factory", Purpose = "WeightLoss" },
            new() { Name = "Lean Body Lab", Purpose = "WeightLoss" },
            new() { Name = "Burn and Tone", Purpose = "WeightLoss" },
            new() { Name = "Metabolic Fire", Purpose = "WeightLoss" },
            new() { Name = "Shape Up", Purpose = "WeightLoss" },
            new() { Name = "Rapid Burn", Purpose = "WeightLoss" },
            new() { Name = "Trim and Fit", Purpose = "WeightLoss" },
            new() { Name = "Sweat Storm", Purpose = "WeightLoss" },
            new() { Name = "Body Burn Flow", Purpose = "WeightLoss" },
            new() { Name = "Fat Burn Circuit", Purpose = "WeightLoss" },
            new() { Name = "Burn Boost", Purpose = "WeightLoss" },
            new() { Name = "Lean Up Session", Purpose = "WeightLoss" },
            new() { Name = "Sweat and Sculpt", Purpose = "WeightLoss" },
            new() { Name = "Weight Cut Cardio", Purpose = "WeightLoss" },
            new() { Name = "Thermo Burn", Purpose = "WeightLoss" },
            new() { Name = "Body Reset", Purpose = "WeightLoss" },
            new() { Name = "Shred Factory", Purpose = "WeightLoss" },
            new() { Name = "Slim Body Fusion", Purpose = "WeightLoss" },
            new() { Name = "Burn Mode", Purpose = "WeightLoss" },
            new() { Name = "Cardio Slim", Purpose = "WeightLoss" },
            new() { Name = "Lean Shape Studio", Purpose = "WeightLoss" },
            new() { Name = "Drop Zone", Purpose = "WeightLoss" },
            new() { Name = "Weight Loss Ignite", Purpose = "WeightLoss" },
            new() { Name = "Sweat Focus", Purpose = "WeightLoss" },
            new() { Name = "Metafit Burn", Purpose = "WeightLoss" },
            new() { Name = "Shred Lab", Purpose = "WeightLoss" },
            new() { Name = "Body Trim Camp", Purpose = "WeightLoss" },
            new() { Name = "Burn Flex", Purpose = "WeightLoss" },
            new() { Name = "Lean Form", Purpose = "WeightLoss" },
            new() { Name = "Thermic Motion", Purpose = "WeightLoss" },
            new() { Name = "Fit Burn Express", Purpose = "WeightLoss" },
            new() { Name = "Sculpt and Sweat", Purpose = "WeightLoss" },
            new() { Name = "Zero In Burn", Purpose = "WeightLoss" },

            new() { Name = "Cardio Rush", Purpose = "Cardio" },
            new() { Name = "Endurance Flow", Purpose = "Cardio" },
            new() { Name = "Heart Beat Session", Purpose = "Cardio" },
            new() { Name = "Cardio Pulse", Purpose = "Cardio" },
            new() { Name = "Aerobic Energy", Purpose = "Cardio" },
            new() { Name = "Run and Burn", Purpose = "Cardio" },
            new() { Name = "Cycle Motion", Purpose = "Cardio" },
            new() { Name = "Cardio Core Mix", Purpose = "Cardio" },
            new() { Name = "Fast Lane Fitness", Purpose = "Cardio" },
            new() { Name = "Endurance Builder", Purpose = "Cardio" },
            new() { Name = "Sweat Ride", Purpose = "Cardio" },
            new() { Name = "Pulse Ride", Purpose = "Cardio" },
            new() { Name = "Cardio Drive", Purpose = "Cardio" },
            new() { Name = "Heart Pump", Purpose = "Cardio" },
            new() { Name = "Fit Endurance", Purpose = "Cardio" },
            new() { Name = "Speed Step", Purpose = "Cardio" },
            new() { Name = "Energy Sprint", Purpose = "Cardio" },
            new() { Name = "Endurance Circuit", Purpose = "Cardio" },
            new() { Name = "Cardio Challenge", Purpose = "Cardio" },
            new() { Name = "Motion Boost", Purpose = "Cardio" },
            new() { Name = "Aerofit Session", Purpose = "Cardio" },
            new() { Name = "Pulse and Pace", Purpose = "Cardio" },
            new() { Name = "Cardio Engine", Purpose = "Cardio" },
            new() { Name = "Speed Burner", Purpose = "Cardio" },
            new() { Name = "Step Blast", Purpose = "Cardio" },
            new() { Name = "Cardio Factory", Purpose = "Cardio" },
            new() { Name = "Pace Builder", Purpose = "Cardio" },
            new() { Name = "Spin and Sweat", Purpose = "Cardio" },
            new() { Name = "Enduro Motion", Purpose = "Cardio" },
            new() { Name = "Breath and Burn", Purpose = "Cardio" },
            new() { Name = "Cardio 360", Purpose = "Cardio" },
            new() { Name = "Step Pulse", Purpose = "Cardio" },
            new() { Name = "Run Fit Lab", Purpose = "Cardio" },
            new() { Name = "Cardio Storm", Purpose = "Cardio" },
            new() { Name = "Tempo Motion", Purpose = "Cardio" },
            new() { Name = "Aerobic Core", Purpose = "Cardio" },
            new() { Name = "Endurance Rush", Purpose = "Cardio" },
            new() { Name = "Pace Up", Purpose = "Cardio" },
            new() { Name = "Cardio Sprint Lab", Purpose = "Cardio" },
            new() { Name = "Energy Ride", Purpose = "Cardio" },

            new() { Name = "Kick Start Combat", Purpose = "MartialArts" },
            new() { Name = "Boxing Basics", Purpose = "MartialArts" },
            new() { Name = "Combat Flow", Purpose = "MartialArts" },
            new() { Name = "Martial Motion", Purpose = "MartialArts" },
            new() { Name = "Kickboxing Power", Purpose = "MartialArts" },
            new() { Name = "Strike Zone", Purpose = "MartialArts" },
            new() { Name = "Fight Fit", Purpose = "MartialArts" },
            new() { Name = "Combat Conditioning", Purpose = "MartialArts" },
            new() { Name = "Punch and Move", Purpose = "MartialArts" },
            new() { Name = "Warrior Session", Purpose = "MartialArts" },
            new() { Name = "Karate Motion", Purpose = "MartialArts" },
            new() { Name = "Muay Thai Core", Purpose = "MartialArts" },
            new() { Name = "Strike and Sweat", Purpose = "MartialArts" },
            new() { Name = "Martial Arts Lab", Purpose = "MartialArts" },
            new() { Name = "Combat Burn", Purpose = "MartialArts" },
            new() { Name = "Power Kick", Purpose = "MartialArts" },
            new() { Name = "Shadow Boxing", Purpose = "MartialArts" },
            new() { Name = "Defense Drill", Purpose = "MartialArts" },
            new() { Name = "Fight Engine", Purpose = "MartialArts" },
            new() { Name = "Combat Pulse", Purpose = "MartialArts" },
            new() { Name = "Kick and Core", Purpose = "MartialArts" },
            new() { Name = "Box Fit Pro", Purpose = "MartialArts" },
            new() { Name = "Warrior Conditioning", Purpose = "MartialArts" },
            new() { Name = "Striking Fundamentals", Purpose = "MartialArts" },
            new() { Name = "Martial Fusion", Purpose = "MartialArts" },
            new() { Name = "Boxing Circuit", Purpose = "MartialArts" },
            new() { Name = "Combat Energy", Purpose = "MartialArts" },
            new() { Name = "Strike Flow", Purpose = "MartialArts" },
            new() { Name = "Fighter Core", Purpose = "MartialArts" },
            new() { Name = "Kickstorm", Purpose = "MartialArts" },
            new() { Name = "Power Combat", Purpose = "MartialArts" },
            new() { Name = "Punch Lab", Purpose = "MartialArts" },
            new() { Name = "Martial Burn", Purpose = "MartialArts" },
            new() { Name = "Combat 360", Purpose = "MartialArts" },
            new() { Name = "Strike Builder", Purpose = "MartialArts" },
            new() { Name = "Warrior Move", Purpose = "MartialArts" },
            new() { Name = "Kickboxing Rush", Purpose = "MartialArts" },
            new() { Name = "Combat Focus", Purpose = "MartialArts" },
            new() { Name = "Box and Burn", Purpose = "MartialArts" },
            new() { Name = "Fight Motion", Purpose = "MartialArts" },

            new() { Name = "Stretch Flow", Purpose = "Flexibility" },
            new() { Name = "Mobility Basics", Purpose = "Flexibility" },
            new() { Name = "Yoga Relax", Purpose = "Flexibility" },
            new() { Name = "Pilates Balance", Purpose = "Flexibility" },
            new() { Name = "Body Flex", Purpose = "Flexibility" },
            new() { Name = "Flex and Breathe", Purpose = "Flexibility" },
            new() { Name = "Core Stretch", Purpose = "Flexibility" },
            new() { Name = "Mobility Motion", Purpose = "Flexibility" },
            new() { Name = "Calm Body Flow", Purpose = "Flexibility" },
            new() { Name = "Balance Studio", Purpose = "Flexibility" },
            new() { Name = "Stretch and Recover", Purpose = "Flexibility" },
            new() { Name = "Gentle Flow", Purpose = "Flexibility" },
            new() { Name = "Flexibility Lab", Purpose = "Flexibility" },
            new() { Name = "Yoga Energy", Purpose = "Flexibility" },
            new() { Name = "Pilates Core", Purpose = "Flexibility" },
            new() { Name = "Recovery Motion", Purpose = "Flexibility" },
            new() { Name = "Deep Stretch", Purpose = "Flexibility" },
            new() { Name = "Balance and Flow", Purpose = "Flexibility" },
            new() { Name = "Flexible Body", Purpose = "Flexibility" },
            new() { Name = "Stretch Reset", Purpose = "Flexibility" },
            new() { Name = "Mobility Reset", Purpose = "Flexibility" },
            new() { Name = "Yoga Calm", Purpose = "Flexibility" },
            new() { Name = "Pilates Flow Pro", Purpose = "Flexibility" },
            new() { Name = "Flex Fusion", Purpose = "Flexibility" },
            new() { Name = "Posture and Stretch", Purpose = "Flexibility" },
            new() { Name = "Body Alignment", Purpose = "Flexibility" },
            new() { Name = "Stretch Therapy", Purpose = "Flexibility" },
            new() { Name = "Mobility Builder", Purpose = "Flexibility" },
            new() { Name = "Flex Start", Purpose = "Flexibility" },
            new() { Name = "Calm Core", Purpose = "Flexibility" },
            new() { Name = "Yoga Restore", Purpose = "Flexibility" },
            new() { Name = "Pilates Precision", Purpose = "Flexibility" },
            new() { Name = "Flexibility Focus", Purpose = "Flexibility" },
            new() { Name = "Stretch and Stabilize", Purpose = "Flexibility" },
            new() { Name = "Mobility 360", Purpose = "Flexibility" },
            new() { Name = "Body Ease", Purpose = "Flexibility" },
            new() { Name = "Flow and Lengthen", Purpose = "Flexibility" },
            new() { Name = "Recovery Stretch Lab", Purpose = "Flexibility" },
            new() { Name = "Total Body Flex", Purpose = "Flexibility" },
            new() { Name = "Mindful Mobility", Purpose = "Flexibility" }
        };

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

            var additionalUsers = GenerateAdditionalUsers(userHash, userSalt, 400);

            var allUsers = baseUsers.Concat(additionalUsers).ToList();

            modelBuilder.Entity<User>().HasData(allUsers);
            modelBuilder.Entity<UserRole>().HasData(GenerateUserRoles(allUsers));

            modelBuilder.Entity<Membership>().HasData(
                new Membership
                {
                    Id = 1,
                    Name = "Basic",
                    MonthlyPrice = 30,
                    YearPrice = 300,
                    CreatedAt = new DateTime(2025, 1, 1)
                },
                new Membership
                {
                    Id = 2,
                    Name = "Standard",
                    MonthlyPrice = 45,
                    YearPrice = 450,
                    CreatedAt = new DateTime(2025, 1, 1)
                },
                new Membership
                {
                    Id = 3,
                    Name = "Premium",
                    MonthlyPrice = 60,
                    YearPrice = 600,
                    CreatedAt = new DateTime(2025, 1, 1)
                },
                new Membership
                {
                    Id = 4,
                    Name = "VIP",
                    MonthlyPrice = 80,
                    YearPrice = 800,
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

            var harisMember = membershipSeed.Members.First(x => x.UserId == 11);
            harisMember.MembershipId = 1;
            harisMember.PaymentDate = new DateTime(2025, 1, 18);
            harisMember.ExpirationDate = new DateTime(2026, 1, 18);

            var harisPayment = membershipSeed.Payments.First(x => x.UserId == 11);
            harisPayment.MembershipId = 1;
            harisPayment.Amount = 300m;
            harisPayment.PaymentDate = new DateTime(2025, 1, 18);
            harisPayment.PaidAt = new DateTime(2025, 1, 18);
            harisPayment.BillingPeriod = "yearly";

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

            modelBuilder.Entity<Reservation>().HasData(
    new Reservation
    {
        Id = 10006,
        UserId = 11,
        TrainingId = 4, 
        CreatedAt = new DateTime(2025, 1, 12),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 1, 14),
        CancelReason = "Privatne obaveze",

    },
    new Reservation
    {
        Id = 10007,
        UserId = 11,
        TrainingId = 44, 
        CreatedAt = new DateTime(2025, 1, 15),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 1, 17),
        CancelReason = "Prehlada",

    },
    new Reservation
    {
        Id = 10008,
        UserId = 11,
        TrainingId = 45, 
        CreatedAt = new DateTime(2025, 1, 17),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 1, 19),
        CancelReason = "Promjena rasporeda",

    },
    new Reservation
    {
        Id = 10009,
        UserId = 11,
        TrainingId = 57, 
        CreatedAt = new DateTime(2025, 2, 2),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 2, 4),
        CancelReason = "Poslovne obaveze",

    },
    new Reservation
    {
        Id = 10010,
        UserId = 11,
        TrainingId = 52,
        CreatedAt = new DateTime(2025, 3, 9),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 3, 11),
        CancelReason = "Putovanje",

    },
    new Reservation
    {
        Id = 10011,
        UserId = 11,
        TrainingId = 51,
        CreatedAt = new DateTime(2025, 3, 10),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 3, 12),
        CancelReason = "Zdravstveni razlozi",

    },
    new Reservation
    {
        Id = 10012,
        UserId = 11,
        TrainingId = 1, 
        CreatedAt = new DateTime(2025, 3, 14),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 3, 16),
        CancelReason = "Neodgodive obaveze",

    },
    new Reservation
    {
        Id = 10013,
        UserId = 11,
        TrainingId = 24, 
        CreatedAt = new DateTime(2025, 3, 15),
        Status = "Cancelled",
        CancelledAt = new DateTime(2025, 3, 17),
        CancelReason = "Nedostatak vremena",

    },

    new Reservation
    {
        Id = 10014,
        UserId = 11,
        TrainingId = 2, 
        CreatedAt = new DateTime(2025, 2, 7),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10015,
        UserId = 11,
        TrainingId = 3, 
        CreatedAt = new DateTime(2025, 2, 9),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10016,
        UserId = 11,
        TrainingId = 5, 
        CreatedAt = new DateTime(2025, 1, 19),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10017,
        UserId = 11,
        TrainingId = 6, 
        CreatedAt = new DateTime(2025, 1, 22),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10018,
        UserId = 11,
        TrainingId = 7, 
        CreatedAt = new DateTime(2025, 1, 27),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10019,
        UserId = 11,
        TrainingId = 8, 
        CreatedAt = new DateTime(2025, 2, 2),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10020,
        UserId = 11,
        TrainingId = 9, // 10.2.2025
        CreatedAt = new DateTime(2025, 2, 7),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10021,
        UserId = 11,
        TrainingId = 10, // 15.2.2025
        CreatedAt = new DateTime(2025, 2, 12),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10022,
        UserId = 11,
        TrainingId = 11, // 20.2.2025
        CreatedAt = new DateTime(2025, 2, 17),
        Status = "Confirmed"
    },
    new Reservation
    {
        Id = 10023,
        UserId = 11,
        TrainingId = 12, // 25.2.2025
        CreatedAt = new DateTime(2025, 2, 22),
        Status = "Confirmed"
    }

);

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
                    ExpirationTaskDate = new DateTime(2026, 2, 2),
                    IsFinished = false,
                    UserId = 7
                },
                new WorkerTask
                {
                    Id = 2,
                    Name = "Čišćenje svlačionice",
                    Details = "Detaljno čišćenje muške svlačionice.",
                    CreatedTaskDate = new DateTime(2026, 2, 3),
                    ExpirationTaskDate = new DateTime(2026, 2, 3),
                    IsFinished = true,
                    UserId = 7
                },
                new WorkerTask
                {
                    Id = 3,
                    Name = "Inventura šanka",
                    Details = "Provjeriti stanje proteinskih napitaka.",
                    CreatedTaskDate = new DateTime(2026, 2, 5),
                    ExpirationTaskDate = new DateTime(2026, 2, 6),
                    IsFinished = false,
                    UserId = 8
                },
                new WorkerTask
                {
                    Id = 4,
                    Name = "Organizacija termina",
                    Details = "Rasporediti termine za nove članove.",
                    CreatedTaskDate = new DateTime(2026, 2, 7),
                    ExpirationTaskDate = new DateTime(2026, 2, 8),
                    IsFinished = false,
                    UserId = 8
                },
                new WorkerTask
                {
                    Id = 5,
                    Name = "Ažuriranje članova",
                    Details = "Provjeriti članarine koje ističu ove sedmice.",
                    CreatedTaskDate = new DateTime(2026, 2, 10),
                    ExpirationTaskDate = new DateTime(2026, 2, 12),
                    IsFinished = true,
                    UserId = 9
                },
                new WorkerTask
                {
                    Id = 6,
                    Name = "Priprema sale",
                    Details = "Pripremiti salu za večernji grupni trening.",
                    CreatedTaskDate = new DateTime(2026, 2, 11),
                    ExpirationTaskDate = new DateTime(2026, 2, 11),
                    IsFinished = false,
                    UserId = 9
                },
                new WorkerTask
                {
                    Id = 7,
                    Name = "Marketing objava",
                    Details = "Objaviti promociju na društvenim mrežama.",
                    CreatedTaskDate = new DateTime(2026, 2, 13),
                    ExpirationTaskDate = new DateTime(2026, 2, 14),
                    IsFinished = false,
                    UserId = 10
                },
                new WorkerTask
                {
                    Id = 8,
                    Name = "Pregled rezervacija",
                    Details = "Provjeriti rezervacije za vikend termine.",
                    CreatedTaskDate = new DateTime(2026, 2, 15),
                    ExpirationTaskDate = new DateTime(2026, 2, 16),
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
                    Status = "Active",
                    ValidFrom = new DateTime(2026, 1, 1),
                    ValidTo = new DateTime(2026, 12, 31),
                    IsLockedForEdit = true,
                    CanDelete = false,
                    RedemptionCount = 4
                },
                new Reward
                {
                    Id = 2,
                    Name = "1 dan besplatne članarine",
                    Description = "Jedan dan besplatnog treninga.",
                    RequiredPoints = 250,
                    Status = "Active",
                    ValidFrom = new DateTime(2026, 2, 1),
                    ValidTo = new DateTime(2026, 11, 30),
                    IsLockedForEdit = true,
                    CanDelete = false,
                    RedemptionCount = 2
                },
                new Reward
                {
                    Id = 3,
                    Name = "Personalni trening - 30 min",
                    Description = "Besplatan personalni trening u trajanju 30 minuta.",
                    RequiredPoints = 500,
                    Status = "Planned",
                    ValidFrom = new DateTime(2026, 5, 1),
                    ValidTo = new DateTime(2026, 9, 30),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 0
                },
                new Reward
                {
                    Id = 4,
                    Name = "20% popusta na članarinu",
                    Description = "Popust od 20% na narednu članarinu.",
                    RequiredPoints = 750,
                    Status = "Planned",
                    ValidFrom = new DateTime(2026, 6, 1),
                    ValidTo = new DateTime(2026, 12, 31),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 0
                },
                new Reward
                {
                    Id = 5,
                    Name = "Gymify premium majica",
                    Description = "Ekskluzivna Gymify majica.",
                    RequiredPoints = 1000,
                    Status = "SoftDeleted",
                    ValidFrom = new DateTime(2026, 1, 15),
                    ValidTo = new DateTime(2026, 7, 31),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 1
                },
                new Reward
                {
                    Id = 6,
                    Name = "Besplatan smoothie",
                    Description = "Akcijska nagrada koja je bila dostupna ograničeno vrijeme.",
                    RequiredPoints = 150,
                    Status = "Expired",
                    ValidFrom = new DateTime(2025, 1, 1),
                    ValidTo = new DateTime(2025, 3, 31),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 0
                },
                new Reward
                {
                    Id = 7,
                    Name = "2 dana besplatne članarine",
                    Description = "Promotivna nagrada iz prethodne sezone.",
                    RequiredPoints = 300,
                    Status = "Expired",
                    ValidFrom = new DateTime(2025, 2, 1),
                    ValidTo = new DateTime(2025, 5, 31),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 3
                },
                new Reward
                {
                    Id = 8,
                    Name = "Gymify peškir",
                    Description = "Posebna nagrada iz stare loyalty ponude.",
                    RequiredPoints = 600,
                    Status = "Expired",
                    ValidFrom = new DateTime(2025, 4, 1),
                    ValidTo = new DateTime(2025, 8, 31),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 1
                },
                new Reward
                {
                    Id = 9,
                    Name = "Besplatan proteinski bar",
                    Description = "Jedan proteinski bar gratis uz posjetu teretani.",
                    RequiredPoints = 120,
                    Status = "Active",
                    ValidFrom = new DateTime(2026, 3, 1),
                    ValidTo = new DateTime(2026, 8, 31),
                    IsLockedForEdit = true,
                    CanDelete = false,
                    RedemptionCount = 5
                },
                new Reward
                {
                    Id = 10,
                    Name = "Mjesec dana locker ormarića",
                    Description = "Besplatno korištenje ormarića u trajanju od mjesec dana.",
                    RequiredPoints = 450,
                    Status = "Planned",
                    ValidFrom = new DateTime(2026, 7, 1),
                    ValidTo = new DateTime(2026, 10, 31),
                    IsLockedForEdit = false,
                    CanDelete = true,
                    RedemptionCount = 0
                }
            );

            modelBuilder.Entity<UserReward>().HasData(
    new UserReward
    {
        Id = 1,
        UserId = 11,
        RewardId = 6,
        Code = "EJK65HC",
        RedeemedAt = new DateTime(2025, 3, 10),
        Status = "Used"
    },
    new UserReward
    {
        Id = 2,
        UserId = 11,
        RewardId = 7,
        Code = "7MZ4X1WQ",
        RedeemedAt = new DateTime(2025, 4, 22),
        Status = "Used"
    },
    new UserReward
    {
        Id = 3,
        UserId = 11,
        RewardId = 1,
        Code = "1BTR8LIP",
        RedeemedAt = new DateTime(2026, 2, 15),
        Status = "Active"
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
            var usedFullNames = new HashSet<string>();

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

                var (firstName, lastName) = GetUniqueNameCombination(random, usedFullNames);

                users.Add(new User
                {
                    Id = id,
                    FirstName = firstName,
                    LastName = lastName,
                    Username = $"{firstName.ToLower()}{id}",
                    Email = $"{firstName.ToLower()}.{lastName.ToLower()}{id}@gymify.com",
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

                var (firstName, lastName) = GetUniqueNameCombination(random, usedFullNames);

                users.Add(new User
                {
                    Id = id,
                    FirstName = firstName,
                    LastName = lastName,
                    Username = $"{firstName.ToLower()}.{lastName.ToLower()}{id}",
                    Email = $"{firstName.ToLower()}.{lastName.ToLower()}{id}@gymify.com",
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

        private static (string firstName, string lastName) GetUniqueNameCombination(
            Random random,
            HashSet<string> usedFullNames)
        {
            while (true)
            {
                var firstName = FirstNames[random.Next(FirstNames.Length)];
                var lastName = LastNames[random.Next(LastNames.Length)];

                var fullNameKey = $"{firstName}|{lastName}";

                if (usedFullNames.Add(fullNameKey))
                {
                    return (firstName, lastName);
                }
            }
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
            var shuffledSeedItems = TrainingSeedItems
                .OrderBy(x => random.Next())
                .Take(120)
                .ToList();

            int id = 1;

            for (int i = 0; i < 60; i++)
            {
                int trainerId = trainerIds[random.Next(trainerIds.Count)];
                int month = random.Next(1, 13);
                int day = random.Next(1, 25);
                int duration = random.Next(35, 61);

                var seedItem = shuffledSeedItems[i];
                var startDate = new DateTime(2025, month, day, random.Next(6, 21), 0, 0);

                trainings.Add(new Training
                {
                    Id = id++,
                    UserId = trainerId,
                    Name = seedItem.Name,
                    DurationMinutes = duration,
                    IntensityLevel = random.Next(1, 6),
                    Purpose = seedItem.Purpose,
                    MaxAmountOfParticipants = random.Next(10, 20),
                    CurrentParticipants = 0,
                    ParticipatedOfAllTime = random.Next(50, 300),
                    IsParticipationCounted = true,
                    StartDate = startDate,
                    TrainingImage = $"https://picsum.photos/seed/training{id}/600/400"
                });
            }

            for (int i = 0; i < 60; i++)
            {
                int trainerId = trainerIds[random.Next(trainerIds.Count)];
                int month = random.Next(1, 13);
                int day = random.Next(1, 25);
                int duration = random.Next(35, 61);

                var seedItem = shuffledSeedItems[60 + i];
                var startDate = new DateTime(2026, month, day, random.Next(6, 21), 0, 0);

                trainings.Add(new Training
                {
                    Id = id++,
                    UserId = trainerId,
                    Name = seedItem.Name,
                    DurationMinutes = duration,
                    IntensityLevel = random.Next(1, 6),
                    Purpose = seedItem.Purpose,
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