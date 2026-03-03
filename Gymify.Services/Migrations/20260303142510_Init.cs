using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Gymify.Services.Migrations
{
    /// <inheritdoc />
    public partial class Init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Memberships",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MonthlyPrice = table.Column<double>(type: "float", nullable: false),
                    YearPrice = table.Column<double>(type: "float", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Memberships", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Rewards",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    RequiredPoints = table.Column<int>(type: "int", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rewards", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "SpecialOffers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Details = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ValueOfLoyaltyPoints = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SpecialOffers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Username = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UserImage = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DateOfBirth = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsUser = table.Column<bool>(type: "bit", nullable: true),
                    IsAdmin = table.Column<bool>(type: "bit", nullable: true),
                    IsTrener = table.Column<bool>(type: "bit", nullable: true),
                    IsRadnik = table.Column<bool>(type: "bit", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    LastLoginAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    AboutMe = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "LoyaltyPointHistories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AmountPointsParticipation = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LoyaltyPointHistories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_LoyaltyPointHistories_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "LoyaltyPoints",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    TotalPoints = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LoyaltyPoints", x => x.Id);
                    table.ForeignKey(
                        name: "FK_LoyaltyPoints_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Members",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    MembershipId = table.Column<int>(type: "int", nullable: false),
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ExpirationDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Members", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Members_Memberships_MembershipId",
                        column: x => x.MembershipId,
                        principalTable: "Memberships",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Members_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Payments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    MembershipId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<double>(type: "float", nullable: false),
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    StripePaymentIntentId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PaidAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    PaymentStatus = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Payments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Payments_Memberships_MembershipId",
                        column: x => x.MembershipId,
                        principalTable: "Memberships",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Payments_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    StarNumber = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reviews_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Trainings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TrainingImage = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    MaxAmountOfParticipants = table.Column<int>(type: "int", nullable: false),
                    CurrentParticipants = table.Column<int>(type: "int", nullable: false),
                    ParicipatedOfAllTime = table.Column<int>(type: "int", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Trainings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Trainings_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRewards",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RewardId = table.Column<int>(type: "int", nullable: false),
                    Code = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RedeemedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsUsed = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRewards", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserRewards_Rewards_RewardId",
                        column: x => x.RewardId,
                        principalTable: "Rewards",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRewards_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    DateAssigned = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "WorkerTasks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Details = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedTaskDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ExparationTaskDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsFinished = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkerTasks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_WorkerTasks_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reservations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    TrainingId = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reservations", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reservations_Trainings_TrainingId",
                        column: x => x.TrainingId,
                        principalTable: "Trainings",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reservations_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "Memberships",
                columns: new[] { "Id", "CreatedAt", "MonthlyPrice", "Name", "YearPrice" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 30.0, "Basic", 300.0 },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 45.0, "Standard", 450.0 },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 60.0, "Premium", 600.0 },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 80.0, "VIP", 800.0 }
                });

            migrationBuilder.InsertData(
                table: "Rewards",
                columns: new[] { "Id", "Description", "IsActive", "Name", "RequiredPoints" },
                values: new object[,]
                {
                    { 1, "Dobij besplatan proteinski shake u gym baru.", true, "Besplatan proteinski shake", 100 },
                    { 2, "Jedan dan besplatnog treninga.", true, "1 dan besplatne članarine", 250 },
                    { 3, "Besplatan personalni trening u trajanju 30 minuta.", true, "Personalni trening - 30 min", 500 },
                    { 4, "Popust od 20% na narednu članarinu.", true, "20% popusta na članarinu", 750 },
                    { 5, "Ekskluzivna Gymify majica.", true, "Gymify premium majica", 1000 }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "CreatedAt", "Description", "IsActive", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 3, 14, 25, 9, 567, DateTimeKind.Utc).AddTicks(7469), "", true, "Korisnik" },
                    { 2, new DateTime(2026, 3, 3, 14, 25, 9, 567, DateTimeKind.Utc).AddTicks(7868), "", true, "Admin" },
                    { 3, new DateTime(2026, 3, 3, 14, 25, 9, 567, DateTimeKind.Utc).AddTicks(7869), "", true, "Trener" },
                    { 4, new DateTime(2026, 3, 3, 14, 25, 9, 567, DateTimeKind.Utc).AddTicks(7870), "", true, "Radnik" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "AboutMe", "CreatedAt", "DateOfBirth", "Email", "FirstName", "IsActive", "IsAdmin", "IsRadnik", "IsTrener", "IsUser", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "UserImage", "Username" },
                values: new object[,]
                {
                    { 1, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1995, 5, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "healthcaretest190@gmail.com", "Tarik", true, true, null, null, null, null, "Malic", "HT1i826mFOlRt31EB3gbH/6FAFU2XQ4ByvRETCrqv4Js15JKtmt/U2GxdIoKOv+1nxPm820cBmNThC4m2Hgrhw==", "Q3Wn7boVkQj82awrNf5mxgZoWVM6tzAW3JQl+G54Rie1je+YxAnMIgIu6t5wdXZIFqOfwYvLWDQwl1LFN7aFPogmqLUj4jvJ7E9V6jgExJh4g2iT/RrPx+/vIvjO30Dpobf6ks/2WFNutw8V7XWVzHW6yoIN0XRkaEfCr3dHFGk=", "061111111", null, "tare45" },
                    { 2, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1994, 3, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), "amir@example.com", "Amir", true, true, null, null, null, null, "Ibrahimovic", "HT1i826mFOlRt31EB3gbH/6FAFU2XQ4ByvRETCrqv4Js15JKtmt/U2GxdIoKOv+1nxPm820cBmNThC4m2Hgrhw==", "Q3Wn7boVkQj82awrNf5mxgZoWVM6tzAW3JQl+G54Rie1je+YxAnMIgIu6t5wdXZIFqOfwYvLWDQwl1LFN7aFPogmqLUj4jvJ7E9V6jgExJh4g2iT/RrPx+/vIvjO30Dpobf6ks/2WFNutw8V7XWVzHW6yoIN0XRkaEfCr3dHFGk=", "061111112", null, "amir56" },
                    { 3, "Licencirani fitness trener sa 5 godina iskustva u radu sa klijentima svih uzrasta.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1990, 7, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), "marko@example.com", "Marko", true, null, null, true, null, null, "Markovic", "KaSc4F3Agxkr64QIeXIjXq2ZVIMCvnVCUTAj/xhqlaPjW/hqFsbLT4wA3Bhp5TOPAp0IFD8nZmn6qzwVdTF7UQ==", "OCZFtqf5eeP1fIUsPz3FEwDyPyD8wHlsnPMROK6517IfgadaWsfiL6vZYXe8bGwH2598nnaPusVHyyl8swbFmZlcLB1rF73MlDYUBeeEhOHmaOjEMTs51QD53p9XDHXRl9H0v8SMtNjpFukiGv58W/DkieBOafUPZ0o5g2852nI=", "061111113", null, "marko78" },
                    { 4, "Specijalizovan za kondicionu pripremu i izgradnju mišićne mase.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1989, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "ivan@example.com", "Ivan", true, null, null, true, null, null, "Ivic", "KaSc4F3Agxkr64QIeXIjXq2ZVIMCvnVCUTAj/xhqlaPjW/hqFsbLT4wA3Bhp5TOPAp0IFD8nZmn6qzwVdTF7UQ==", "OCZFtqf5eeP1fIUsPz3FEwDyPyD8wHlsnPMROK6517IfgadaWsfiL6vZYXe8bGwH2598nnaPusVHyyl8swbFmZlcLB1rF73MlDYUBeeEhOHmaOjEMTs51QD53p9XDHXRl9H0v8SMtNjpFukiGv58W/DkieBOafUPZ0o5g2852nI=", "061111114", null, "ivan11" },
                    { 5, "Stručnjak za funkcionalne treninge i planove ishrane.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1992, 9, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "petar@example.com", "Petar", true, null, null, true, null, null, "Petrovic", "KaSc4F3Agxkr64QIeXIjXq2ZVIMCvnVCUTAj/xhqlaPjW/hqFsbLT4wA3Bhp5TOPAp0IFD8nZmn6qzwVdTF7UQ==", "OCZFtqf5eeP1fIUsPz3FEwDyPyD8wHlsnPMROK6517IfgadaWsfiL6vZYXe8bGwH2598nnaPusVHyyl8swbFmZlcLB1rF73MlDYUBeeEhOHmaOjEMTs51QD53p9XDHXRl9H0v8SMtNjpFukiGv58W/DkieBOafUPZ0o5g2852nI=", "061111115", null, "petar21" },
                    { 6, "Posvećen radu sa početnicima i personalizovanim fitness programima.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1993, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "luka@example.com", "Luka", true, null, null, true, null, null, "Lukic", "KaSc4F3Agxkr64QIeXIjXq2ZVIMCvnVCUTAj/xhqlaPjW/hqFsbLT4wA3Bhp5TOPAp0IFD8nZmn6qzwVdTF7UQ==", "OCZFtqf5eeP1fIUsPz3FEwDyPyD8wHlsnPMROK6517IfgadaWsfiL6vZYXe8bGwH2598nnaPusVHyyl8swbFmZlcLB1rF73MlDYUBeeEhOHmaOjEMTs51QD53p9XDHXRl9H0v8SMtNjpFukiGv58W/DkieBOafUPZ0o5g2852nI=", "061111116", null, "luka34" },
                    { 7, "Zadužen za organizaciju termina i podršku članovima teretane.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1996, 4, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "nedim@example.com", "Nedim", true, null, true, null, null, null, "Nedimovic", "mEKsYLYr7LrNygv5cl2qLRtZ/8pADthM2LaLMf2GXBhh918FvdIvk1t7Zk47V5KsDDh76K+kHY7IwSc1FbYRSg==", "gSSXmQP6IqUYEAbt03HSJ+IDy/gEgn4DBG+o/SUBbkTL9ThlVef4XqmvQVXHWsh4RxmXrklFcZUe2fTM3G5yo1D6o09XCQFxEPPBk127IsS5iTLhcrYfaxH3icnn6gXQnlefoE6SeSDL3PpFVMpm9wpJjsVmxyUAHB+Q2ft+t1g=", "061111117", null, "nedim89" },
                    { 8, "Brine o administraciji i svakodnevnom radu fitness centra.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 8, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), "amela@example.com", "Amela", true, null, true, null, null, null, "Amelovic", "mEKsYLYr7LrNygv5cl2qLRtZ/8pADthM2LaLMf2GXBhh918FvdIvk1t7Zk47V5KsDDh76K+kHY7IwSc1FbYRSg==", "gSSXmQP6IqUYEAbt03HSJ+IDy/gEgn4DBG+o/SUBbkTL9ThlVef4XqmvQVXHWsh4RxmXrklFcZUe2fTM3G5yo1D6o09XCQFxEPPBk127IsS5iTLhcrYfaxH3icnn6gXQnlefoE6SeSDL3PpFVMpm9wpJjsVmxyUAHB+Q2ft+t1g=", "061111118", null, "amela900" },
                    { 9, "Odgovoran za korisničku podršku i prijem novih članova.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1995, 11, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "tarik@example.com", "Tarik", true, null, true, null, null, null, "Tarikovic", "mEKsYLYr7LrNygv5cl2qLRtZ/8pADthM2LaLMf2GXBhh918FvdIvk1t7Zk47V5KsDDh76K+kHY7IwSc1FbYRSg==", "gSSXmQP6IqUYEAbt03HSJ+IDy/gEgn4DBG+o/SUBbkTL9ThlVef4XqmvQVXHWsh4RxmXrklFcZUe2fTM3G5yo1D6o09XCQFxEPPBk127IsS5iTLhcrYfaxH3icnn6gXQnlefoE6SeSDL3PpFVMpm9wpJjsVmxyUAHB+Q2ft+t1g=", "061111119", null, "tarik345" },
                    { 10, "Koordinira raspored treninga i komunikaciju sa trenerima.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "emina@example.com", "Emina", true, null, true, null, null, null, "Eminovic", "mEKsYLYr7LrNygv5cl2qLRtZ/8pADthM2LaLMf2GXBhh918FvdIvk1t7Zk47V5KsDDh76K+kHY7IwSc1FbYRSg==", "gSSXmQP6IqUYEAbt03HSJ+IDy/gEgn4DBG+o/SUBbkTL9ThlVef4XqmvQVXHWsh4RxmXrklFcZUe2fTM3G5yo1D6o09XCQFxEPPBk127IsS5iTLhcrYfaxH3icnn6gXQnlefoE6SeSDL3PpFVMpm9wpJjsVmxyUAHB+Q2ft+t1g=", "061111120", null, "emina112" },
                    { 11, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2000, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), "korisniktestiranje264@gmail.com", "Haris", true, null, null, null, true, null, "Hasic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111121", null, "haris1" },
                    { 12, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1999, 9, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "denis2@example.com", "Denis", true, null, null, null, true, null, "Denisovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111122", null, "denis2" },
                    { 13, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2001, 2, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "alen3@example.com", "Alen", true, null, null, null, true, null, "Alenovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111123", null, "alen3" },
                    { 14, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 7, 30, 0, 0, 0, 0, DateTimeKind.Unspecified), "kenan4@example.com", "Kenan", true, null, null, null, true, null, "Kenanovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111124", null, "kenan4" },
                    { 15, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 3, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "jasmin5@example.com", "Jasmin", true, null, null, null, true, null, "Jasminovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111125", null, "jasmin5" },
                    { 16, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2002, 10, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), "lejla6@example.com", "Lejla", true, null, null, null, true, null, "Lejlovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111126", null, "lejla6" },
                    { 17, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2001, 5, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "sara7@example.com", "Sara", true, null, null, null, true, null, "Saric", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111127", null, "sara7" },
                    { 18, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1999, 12, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "amina8@example.com", "Amina", true, null, null, null, true, null, "Aminovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111128", null, "amina8" },
                    { 19, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 8, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "emir9@example.com", "Emir", true, null, null, null, true, null, "Emirovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111129", null, "emir9" },
                    { 20, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "nermin10@example.com", "Nermin", true, null, null, null, true, null, "Nerminovic", "bwcVclt3ElEToyB2QbQqQB2sPlcm+LM53K424LnNEzWiXgDqiULVxmbu6AaF3JgbSDPpbWVEoZ5Y0lLU5/yNrg==", "CN38GgX0NtmVsCMifi3Sc8vCisaF20FsAwJ+Y0NjCeTkLWZwXYWoOfUzpDs15QM5ccvnLS5HEiTj07qvKgVJcWJTsBEa53QR5ymGEeY5gPWd3lmAFYCoGnK/icu6t5hu/26Ym0OtNX2da6LV8AvpcZI/VkWyabossRhMIm2txRM=", "061111130", null, "nermin10" }
                });

            migrationBuilder.InsertData(
                table: "LoyaltyPoints",
                columns: new[] { "Id", "TotalPoints", "UserId" },
                values: new object[,]
                {
                    { 1, 120, 11 },
                    { 2, 350, 12 },
                    { 3, 780, 13 }
                });

            migrationBuilder.InsertData(
                table: "Members",
                columns: new[] { "Id", "ExpirationDate", "MembershipId", "PaymentDate", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 28, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(2989), 2, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(2867), 11 },
                    { 2, new DateTime(2026, 6, 1, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3188), 2, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3188), 12 },
                    { 3, new DateTime(2026, 8, 30, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3192), 3, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3191), 13 },
                    { 4, new DateTime(2027, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3193), 4, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3193), 14 },
                    { 5, new DateTime(2026, 2, 26, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3194), 1, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3194), 15 },
                    { 6, new DateTime(2026, 6, 1, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3211), 2, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3210), 16 },
                    { 7, new DateTime(2026, 2, 21, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3212), 3, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3212), 17 },
                    { 8, new DateTime(2026, 2, 26, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3213), 4, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3213), 18 },
                    { 9, new DateTime(2026, 4, 2, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3214), 1, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3214), 19 },
                    { 10, new DateTime(2026, 2, 21, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3215), 2, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(3215), 20 }
                });

            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "Id", "Content", "CreatedAt", "Title", "UserId" },
                values: new object[,]
                {
                    { 1, "Funkcionalni trening planiran za večeras je otkazan.", new DateTime(2026, 2, 10, 12, 0, 0, 0, DateTimeKind.Unspecified), "Obavijest", 1 },
                    { 2, "Termini pilatesa za sljedeću sedmicu su Uto-Sri-Pet 17:00.", new DateTime(2026, 2, 12, 9, 30, 0, 0, DateTimeKind.Unspecified), "Obavijest", 2 },
                    { 3, "Podsjetnik: članarine se mogu produžiti do 25. u mjesecu.", new DateTime(2026, 2, 14, 15, 10, 0, 0, DateTimeKind.Unspecified), "Obavijest", 7 },
                    { 4, "U subotu radimo skraćeno: 09:00–14:00.", new DateTime(2026, 2, 15, 11, 0, 0, 0, DateTimeKind.Unspecified), "Obavijest", 8 },
                    { 5, "Uveden je novi VIP paket članarine. Pogledajte detalje na recepciji.", new DateTime(2026, 2, 16, 10, 0, 0, 0, DateTimeKind.Unspecified), "Obavijest", 1 },
                    { 6, "Molimo članove da nakon treninga vraćaju opremu na mjesto.", new DateTime(2026, 2, 17, 18, 0, 0, 0, DateTimeKind.Unspecified), "Obavijest", 9 }
                });

            migrationBuilder.InsertData(
                table: "Payments",
                columns: new[] { "Id", "Amount", "MembershipId", "PaidAt", "PaymentDate", "PaymentStatus", "StripePaymentIntentId", "UserId" },
                values: new object[,]
                {
                    { 1, 45.0, 2, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 11 },
                    { 2, 45.0, 2, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 12 },
                    { 3, 60.0, 3, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 13 },
                    { 4, 80.0, 4, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 14 },
                    { 5, 30.0, 1, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 15 },
                    { 6, 45.0, 2, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 16 },
                    { 7, 60.0, 3, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 17 },
                    { 8, 80.0, 4, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 18 },
                    { 9, 30.0, 1, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 19 },
                    { 10, 45.0, 2, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Paid", null, 20 }
                });

            migrationBuilder.InsertData(
                table: "Reviews",
                columns: new[] { "Id", "Message", "StarNumber", "UserId" },
                values: new object[,]
                {
                    { 1, "Odlična teretana, čisto i uredno. Preporuka!", 5, 11 },
                    { 2, "Treninzi su super, ali bi volio više večernjih termina.", 4, 12 },
                    { 3, "Osoblje je ljubazno i uvijek spremno pomoći.", 5, 13 },
                    { 4, "Dobra oprema, ponekad gužva u špici.", 4, 14 },
                    { 5, "Zadovoljan sam. Treneri su stvarno profesionalni.", 5, 15 },
                    { 6, "Sve je top, jedino bi muzika mogla biti malo tiša.", 4, 16 },
                    { 7, "Najbolja teretana u gradu!", 5, 17 },
                    { 8, "Sviđa mi se što je uvijek čisto i uredno.", 5, 18 },
                    { 9, "Dobro iskustvo, ali bih volio više sprava za noge.", 4, 19 },
                    { 10, "Super atmosfera i odlična organizacija.", 5, 20 }
                });

            migrationBuilder.InsertData(
                table: "Trainings",
                columns: new[] { "Id", "CurrentParticipants", "MaxAmountOfParticipants", "Name", "ParicipatedOfAllTime", "StartDate", "TrainingImage", "UserId" },
                values: new object[,]
                {
                    { 1, 10, 15, "HIIT", 120, new DateTime(2026, 6, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/hiit/600/400", 3 },
                    { 2, 12, 20, "Cardio Blast", 185, new DateTime(2026, 6, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/cardioblast/600/400", 3 },
                    { 3, 14, 18, "CrossFit", 240, new DateTime(2026, 6, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/crossfit/600/400", 4 },
                    { 4, 8, 12, "Yoga Flow", 95, new DateTime(2026, 6, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/yogaflow/600/400", 4 },
                    { 5, 6, 10, "Pilates", 80, new DateTime(2026, 6, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/pilates/600/400", 5 },
                    { 6, 11, 16, "Strength Training", 210, new DateTime(2026, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/strength/600/400", 5 },
                    { 7, 9, 14, "Boxing", 160, new DateTime(2026, 6, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/boxing/600/400", 6 },
                    { 8, 7, 15, "Kickboxing", 140, new DateTime(2026, 6, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/kickboxing/600/400", 6 },
                    { 9, 13, 20, "Morning Fitness", 175, new DateTime(2026, 6, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/morningfitness/600/400", 3 },
                    { 10, 15, 18, "Evening Cardio", 190, new DateTime(2026, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/eveningcardio/600/400", 4 },
                    { 11, 10, 17, "Body Pump", 155, new DateTime(2026, 6, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/bodypump/600/400", 5 },
                    { 12, 8, 14, "Functional Training", 130, new DateTime(2026, 6, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/functional/600/400", 6 },
                    { 13, 6, 12, "Stretching", 70, new DateTime(2026, 6, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/stretching/600/400", 3 },
                    { 14, 18, 20, "Bootcamp", 260, new DateTime(2026, 6, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/bootcamp/600/400", 4 },
                    { 15, 9, 15, "Abs Workout", 145, new DateTime(2026, 6, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/absworkout/600/400", 5 },
                    { 16, 5, 10, "Powerlifting", 110, new DateTime(2026, 6, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/powerlifting/600/400", 6 },
                    { 17, 14, 20, "Zumba", 220, new DateTime(2026, 6, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/zumba/600/400", 3 },
                    { 18, 12, 18, "Aerobics", 165, new DateTime(2026, 6, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/aerobics/600/400", 4 },
                    { 19, 11, 16, "Circuit Training", 180, new DateTime(2026, 6, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/circuit/600/400", 5 },
                    { 20, 10, 15, "Core Workout", 150, new DateTime(2026, 6, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/core/600/400", 6 },
                    { 21, 11, 15, "HIIT (Feb)", 0, new DateTime(2026, 2, 10, 18, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/hiitfeb/600/400", 3 },
                    { 22, 9, 12, "Yoga Flow (Feb)", 0, new DateTime(2026, 2, 14, 19, 30, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/yogafeb/600/400", 4 },
                    { 23, 13, 16, "Strength Training (Feb)", 0, new DateTime(2026, 2, 20, 17, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/strengthfeb/600/400", 5 },
                    { 24, 10, 14, "Boxing (Feb)", 0, new DateTime(2026, 2, 25, 20, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/boxingfeb/600/400", 6 }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(720), 2, 1 },
                    { 2, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1108), 2, 2 },
                    { 3, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1109), 3, 3 },
                    { 4, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1110), 3, 4 },
                    { 5, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1111), 3, 5 },
                    { 6, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1112), 3, 6 },
                    { 7, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1112), 4, 7 },
                    { 8, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1129), 4, 8 },
                    { 9, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1130), 4, 9 },
                    { 10, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1131), 4, 10 },
                    { 11, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1131), 1, 11 },
                    { 12, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1132), 1, 12 },
                    { 13, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1133), 1, 13 },
                    { 14, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1133), 1, 14 },
                    { 15, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1134), 1, 15 },
                    { 16, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1135), 1, 16 },
                    { 17, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1135), 1, 17 },
                    { 18, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1136), 1, 18 },
                    { 19, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1137), 1, 19 },
                    { 20, new DateTime(2026, 3, 3, 14, 25, 9, 573, DateTimeKind.Utc).AddTicks(1137), 1, 20 }
                });

            migrationBuilder.InsertData(
                table: "WorkerTasks",
                columns: new[] { "Id", "CreatedTaskDate", "Details", "ExparationTaskDate", "IsFinished", "Name", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Izvršiti dnevnu provjeru sprava u sali 1.", new DateTime(2026, 2, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Provjera opreme", 7 },
                    { 2, new DateTime(2026, 2, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "Detaljno čišćenje muške svlačionice.", new DateTime(2026, 2, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "Čišćenje svlačionice", 7 },
                    { 3, new DateTime(2026, 2, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Provjeriti stanje proteinskih napitaka.", new DateTime(2026, 2, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Inventura šanka", 8 },
                    { 4, new DateTime(2026, 2, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), "Rasporediti termine za nove članove.", new DateTime(2026, 2, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Organizacija termina", 8 },
                    { 5, new DateTime(2026, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Provjeriti članarine koje ističu ove sedmice.", new DateTime(2026, 2, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "Ažuriranje članova", 9 },
                    { 6, new DateTime(2026, 2, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "Pripremiti salu za večernji grupni trening.", new DateTime(2026, 2, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Priprema sale", 9 },
                    { 7, new DateTime(2026, 2, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), "Objaviti promociju na društvenim mrežama.", new DateTime(2026, 2, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Marketing objava", 10 },
                    { 8, new DateTime(2026, 2, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "Provjeriti rezervacije za vikend termine.", new DateTime(2026, 2, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "Pregled rezervacija", 10 }
                });

            migrationBuilder.InsertData(
                table: "Reservations",
                columns: new[] { "Id", "CreatedAt", "TrainingId", "UserId" },
                values: new object[,]
                {
                    { 5, new DateTime(2026, 5, 25, 10, 0, 0, 0, DateTimeKind.Unspecified), 1, 12 },
                    { 6, new DateTime(2026, 5, 26, 11, 30, 0, 0, DateTimeKind.Unspecified), 1, 13 },
                    { 7, new DateTime(2026, 5, 27, 9, 15, 0, 0, DateTimeKind.Unspecified), 2, 14 },
                    { 8, new DateTime(2026, 5, 28, 14, 45, 0, 0, DateTimeKind.Unspecified), 2, 15 },
                    { 9, new DateTime(2026, 5, 29, 16, 0, 0, 0, DateTimeKind.Unspecified), 3, 16 },
                    { 10, new DateTime(2026, 5, 30, 18, 20, 0, 0, DateTimeKind.Unspecified), 3, 17 },
                    { 11, new DateTime(2026, 5, 31, 12, 10, 0, 0, DateTimeKind.Unspecified), 4, 18 },
                    { 12, new DateTime(2026, 6, 1, 8, 5, 0, 0, DateTimeKind.Unspecified), 4, 19 },
                    { 13, new DateTime(2026, 6, 2, 13, 0, 0, 0, DateTimeKind.Unspecified), 5, 20 },
                    { 14, new DateTime(2026, 6, 3, 15, 25, 0, 0, DateTimeKind.Unspecified), 6, 12 },
                    { 15, new DateTime(2026, 6, 4, 17, 40, 0, 0, DateTimeKind.Unspecified), 7, 13 },
                    { 16, new DateTime(2026, 6, 5, 19, 10, 0, 0, DateTimeKind.Unspecified), 8, 14 },
                    { 17, new DateTime(2026, 6, 6, 10, 30, 0, 0, DateTimeKind.Unspecified), 9, 15 },
                    { 18, new DateTime(2026, 6, 7, 11, 45, 0, 0, DateTimeKind.Unspecified), 10, 16 },
                    { 19, new DateTime(2026, 6, 8, 9, 0, 0, 0, DateTimeKind.Unspecified), 11, 17 },
                    { 20, new DateTime(2026, 6, 9, 12, 20, 0, 0, DateTimeKind.Unspecified), 12, 18 },
                    { 21, new DateTime(2026, 6, 10, 14, 0, 0, 0, DateTimeKind.Unspecified), 13, 19 },
                    { 22, new DateTime(2026, 6, 11, 16, 30, 0, 0, DateTimeKind.Unspecified), 14, 20 },
                    { 23, new DateTime(2026, 6, 12, 18, 0, 0, 0, DateTimeKind.Unspecified), 15, 12 },
                    { 24, new DateTime(2026, 6, 13, 20, 10, 0, 0, DateTimeKind.Unspecified), 16, 13 },
                    { 25, new DateTime(2026, 6, 14, 9, 15, 0, 0, DateTimeKind.Unspecified), 17, 14 },
                    { 26, new DateTime(2026, 6, 15, 11, 0, 0, 0, DateTimeKind.Unspecified), 18, 15 },
                    { 27, new DateTime(2026, 6, 16, 13, 40, 0, 0, DateTimeKind.Unspecified), 19, 16 },
                    { 28, new DateTime(2026, 6, 17, 15, 55, 0, 0, DateTimeKind.Unspecified), 20, 17 },
                    { 29, new DateTime(2026, 2, 8, 10, 0, 0, 0, DateTimeKind.Unspecified), 21, 12 },
                    { 30, new DateTime(2026, 2, 12, 11, 20, 0, 0, DateTimeKind.Unspecified), 22, 13 },
                    { 31, new DateTime(2026, 2, 18, 9, 45, 0, 0, DateTimeKind.Unspecified), 23, 14 },
                    { 32, new DateTime(2026, 2, 22, 14, 10, 0, 0, DateTimeKind.Unspecified), 24, 15 },
                    { 33, new DateTime(2026, 5, 27, 10, 0, 0, 0, DateTimeKind.Unspecified), 1, 16 },
                    { 34, new DateTime(2026, 5, 27, 10, 30, 0, 0, DateTimeKind.Unspecified), 1, 17 },
                    { 35, new DateTime(2026, 5, 28, 11, 0, 0, 0, DateTimeKind.Unspecified), 1, 18 },
                    { 36, new DateTime(2026, 5, 28, 12, 0, 0, 0, DateTimeKind.Unspecified), 2, 19 },
                    { 37, new DateTime(2026, 5, 29, 9, 15, 0, 0, DateTimeKind.Unspecified), 2, 20 },
                    { 38, new DateTime(2026, 5, 29, 13, 40, 0, 0, DateTimeKind.Unspecified), 2, 11 },
                    { 39, new DateTime(2026, 5, 30, 8, 45, 0, 0, DateTimeKind.Unspecified), 3, 12 },
                    { 40, new DateTime(2026, 5, 30, 12, 10, 0, 0, DateTimeKind.Unspecified), 3, 15 },
                    { 41, new DateTime(2026, 5, 31, 17, 5, 0, 0, DateTimeKind.Unspecified), 3, 20 },
                    { 42, new DateTime(2026, 6, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), 4, 11 },
                    { 43, new DateTime(2026, 6, 1, 10, 20, 0, 0, DateTimeKind.Unspecified), 4, 12 },
                    { 44, new DateTime(2026, 6, 2, 14, 0, 0, 0, DateTimeKind.Unspecified), 4, 13 },
                    { 45, new DateTime(2026, 6, 2, 16, 30, 0, 0, DateTimeKind.Unspecified), 5, 14 },
                    { 46, new DateTime(2026, 6, 3, 11, 15, 0, 0, DateTimeKind.Unspecified), 5, 17 },
                    { 47, new DateTime(2026, 6, 3, 9, 50, 0, 0, DateTimeKind.Unspecified), 6, 18 },
                    { 48, new DateTime(2026, 6, 3, 18, 0, 0, 0, DateTimeKind.Unspecified), 6, 19 },
                    { 49, new DateTime(2026, 6, 4, 12, 45, 0, 0, DateTimeKind.Unspecified), 6, 20 },
                    { 50, new DateTime(2026, 6, 4, 14, 10, 0, 0, DateTimeKind.Unspecified), 7, 11 },
                    { 51, new DateTime(2026, 6, 5, 9, 5, 0, 0, DateTimeKind.Unspecified), 7, 12 },
                    { 52, new DateTime(2026, 6, 5, 10, 0, 0, 0, DateTimeKind.Unspecified), 8, 13 },
                    { 53, new DateTime(2026, 6, 5, 12, 30, 0, 0, DateTimeKind.Unspecified), 8, 14 },
                    { 54, new DateTime(2026, 6, 6, 8, 0, 0, 0, DateTimeKind.Unspecified), 9, 18 },
                    { 55, new DateTime(2026, 6, 6, 9, 25, 0, 0, DateTimeKind.Unspecified), 9, 19 },
                    { 56, new DateTime(2026, 6, 6, 11, 40, 0, 0, DateTimeKind.Unspecified), 9, 20 },
                    { 57, new DateTime(2026, 6, 7, 10, 10, 0, 0, DateTimeKind.Unspecified), 10, 11 },
                    { 58, new DateTime(2026, 6, 7, 13, 0, 0, 0, DateTimeKind.Unspecified), 10, 12 },
                    { 59, new DateTime(2026, 6, 8, 12, 0, 0, 0, DateTimeKind.Unspecified), 11, 13 },
                    { 60, new DateTime(2026, 6, 8, 15, 30, 0, 0, DateTimeKind.Unspecified), 11, 16 },
                    { 61, new DateTime(2026, 6, 9, 9, 45, 0, 0, DateTimeKind.Unspecified), 11, 19 },
                    { 62, new DateTime(2026, 6, 9, 10, 30, 0, 0, DateTimeKind.Unspecified), 12, 14 },
                    { 63, new DateTime(2026, 6, 9, 14, 20, 0, 0, DateTimeKind.Unspecified), 12, 15 },
                    { 64, new DateTime(2026, 6, 10, 9, 0, 0, 0, DateTimeKind.Unspecified), 14, 16 },
                    { 65, new DateTime(2026, 6, 10, 10, 15, 0, 0, DateTimeKind.Unspecified), 14, 17 },
                    { 66, new DateTime(2026, 6, 11, 12, 0, 0, 0, DateTimeKind.Unspecified), 14, 18 },
                    { 67, new DateTime(2026, 6, 12, 11, 0, 0, 0, DateTimeKind.Unspecified), 17, 11 },
                    { 68, new DateTime(2026, 6, 12, 12, 30, 0, 0, DateTimeKind.Unspecified), 17, 12 },
                    { 69, new DateTime(2026, 6, 13, 9, 45, 0, 0, DateTimeKind.Unspecified), 17, 13 },
                    { 70, new DateTime(2026, 6, 14, 15, 0, 0, 0, DateTimeKind.Unspecified), 20, 18 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_LoyaltyPointHistories_UserId",
                table: "LoyaltyPointHistories",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_LoyaltyPoints_UserId",
                table: "LoyaltyPoints",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Members_MembershipId",
                table: "Members",
                column: "MembershipId");

            migrationBuilder.CreateIndex(
                name: "IX_Members_UserId",
                table: "Members",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_MembershipId",
                table: "Payments",
                column: "MembershipId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_UserId",
                table: "Payments",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_TrainingId",
                table: "Reservations",
                column: "TrainingId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_UserId",
                table: "Reservations",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_UserId",
                table: "Reviews",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Trainings_UserId",
                table: "Trainings",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRewards_RewardId",
                table: "UserRewards",
                column: "RewardId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRewards_UserId",
                table: "UserRewards",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_UserId",
                table: "UserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_WorkerTasks_UserId",
                table: "WorkerTasks",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "LoyaltyPointHistories");

            migrationBuilder.DropTable(
                name: "LoyaltyPoints");

            migrationBuilder.DropTable(
                name: "Members");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "Payments");

            migrationBuilder.DropTable(
                name: "Reservations");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "SpecialOffers");

            migrationBuilder.DropTable(
                name: "UserRewards");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "WorkerTasks");

            migrationBuilder.DropTable(
                name: "Memberships");

            migrationBuilder.DropTable(
                name: "Trainings");

            migrationBuilder.DropTable(
                name: "Rewards");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
