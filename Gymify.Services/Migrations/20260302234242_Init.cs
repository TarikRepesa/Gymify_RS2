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
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: false)
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
                table: "Roles",
                columns: new[] { "Id", "CreatedAt", "Description", "IsActive", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 2, 23, 42, 42, 498, DateTimeKind.Utc).AddTicks(1212), "", true, "Korisnik" },
                    { 2, new DateTime(2026, 3, 2, 23, 42, 42, 498, DateTimeKind.Utc).AddTicks(1662), "", true, "Admin" },
                    { 3, new DateTime(2026, 3, 2, 23, 42, 42, 498, DateTimeKind.Utc).AddTicks(1663), "", true, "Trener" },
                    { 4, new DateTime(2026, 3, 2, 23, 42, 42, 498, DateTimeKind.Utc).AddTicks(1664), "", true, "Radnik" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "AboutMe", "CreatedAt", "DateOfBirth", "Email", "FirstName", "IsActive", "IsAdmin", "IsRadnik", "IsTrener", "IsUser", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "UserImage", "Username" },
                values: new object[,]
                {
                    { 1, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1995, 5, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "healthcaretest190@gmail.com", "Tarik", true, true, null, null, null, null, "Malic", "bYEOWlSkXeWIXmWGFkr8RNpUniGDV49U8Ow717MymqrCSvrL+y2kGxYq2YLb55fT8vSfclkXp239tFAfaZ1Vxw==", "md2fiN6Qjn/4Qfvl1sQPV51k/h7x2PcuS6abbyP5W7RaHijwLhV4Vf1wtVDaETB3OsJ3ba7rUCVUrR2HXPAKivnyoQ68d7ZrM4omSOgSJzE7f+bXLDMGt+h8QCOB8PEuY3INyk0CjYt6esFY55aSl35bOHelHOSb3HJ+NuVf7fo=", "061111111", null, "tare45" },
                    { 2, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1994, 3, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), "amir@example.com", "Amir", true, true, null, null, null, null, "Ibrahimovic", "bYEOWlSkXeWIXmWGFkr8RNpUniGDV49U8Ow717MymqrCSvrL+y2kGxYq2YLb55fT8vSfclkXp239tFAfaZ1Vxw==", "md2fiN6Qjn/4Qfvl1sQPV51k/h7x2PcuS6abbyP5W7RaHijwLhV4Vf1wtVDaETB3OsJ3ba7rUCVUrR2HXPAKivnyoQ68d7ZrM4omSOgSJzE7f+bXLDMGt+h8QCOB8PEuY3INyk0CjYt6esFY55aSl35bOHelHOSb3HJ+NuVf7fo=", "061111112", null, "amir56" },
                    { 3, "Licencirani fitness trener sa 5 godina iskustva u radu sa klijentima svih uzrasta.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1990, 7, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), "marko@example.com", "Marko", true, null, null, true, null, null, "Markovic", "GGseWLSbwn5nLFSbQSw+3UpGYrtu6ISAEwVgtHCnp4x1yBb3qYHGOHNATDmnkUbnTancRq9lP9mlUyYsPkXPxw==", "T8MdhlBfJzSIX4ulLs1vUF4RyNayDTsE6/s412h3kL/pxN6Qof0I1AxDJuxhYz8Qf6Fo4ZGMYuVgstBf5GcH/qraY/2pdunYpK7L0dF5w1er1mpibDpdPnkTSDP7neU79askHxzaslFODMb5aPROa7LK0AHGJsRicq+V/Z0iIfo=", "061111113", null, "marko78" },
                    { 4, "Specijalizovan za kondicionu pripremu i izgradnju mišićne mase.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1989, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "ivan@example.com", "Ivan", true, null, null, true, null, null, "Ivic", "GGseWLSbwn5nLFSbQSw+3UpGYrtu6ISAEwVgtHCnp4x1yBb3qYHGOHNATDmnkUbnTancRq9lP9mlUyYsPkXPxw==", "T8MdhlBfJzSIX4ulLs1vUF4RyNayDTsE6/s412h3kL/pxN6Qof0I1AxDJuxhYz8Qf6Fo4ZGMYuVgstBf5GcH/qraY/2pdunYpK7L0dF5w1er1mpibDpdPnkTSDP7neU79askHxzaslFODMb5aPROa7LK0AHGJsRicq+V/Z0iIfo=", "061111114", null, "ivan11" },
                    { 5, "Stručnjak za funkcionalne treninge i planove ishrane.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1992, 9, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "petar@example.com", "Petar", true, null, null, true, null, null, "Petrovic", "GGseWLSbwn5nLFSbQSw+3UpGYrtu6ISAEwVgtHCnp4x1yBb3qYHGOHNATDmnkUbnTancRq9lP9mlUyYsPkXPxw==", "T8MdhlBfJzSIX4ulLs1vUF4RyNayDTsE6/s412h3kL/pxN6Qof0I1AxDJuxhYz8Qf6Fo4ZGMYuVgstBf5GcH/qraY/2pdunYpK7L0dF5w1er1mpibDpdPnkTSDP7neU79askHxzaslFODMb5aPROa7LK0AHGJsRicq+V/Z0iIfo=", "061111115", null, "petar21" },
                    { 6, "Posvećen radu sa početnicima i personalizovanim fitness programima.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1993, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "luka@example.com", "Luka", true, null, null, true, null, null, "Lukic", "GGseWLSbwn5nLFSbQSw+3UpGYrtu6ISAEwVgtHCnp4x1yBb3qYHGOHNATDmnkUbnTancRq9lP9mlUyYsPkXPxw==", "T8MdhlBfJzSIX4ulLs1vUF4RyNayDTsE6/s412h3kL/pxN6Qof0I1AxDJuxhYz8Qf6Fo4ZGMYuVgstBf5GcH/qraY/2pdunYpK7L0dF5w1er1mpibDpdPnkTSDP7neU79askHxzaslFODMb5aPROa7LK0AHGJsRicq+V/Z0iIfo=", "061111116", null, "luka34" },
                    { 7, "Zadužen za organizaciju termina i podršku članovima teretane.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1996, 4, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "nedim@example.com", "Nedim", true, null, true, null, null, null, "Nedimovic", "eTzH2I7r51DzrMwk0p8t0uP/ZlewRbAnzlUR23G1tgJxgo34eezlG5hlCPdC5DcHnn4XO1KFmyIKXuX2lgPyJA==", "6UR7z40QXCreHaDshUU6GcbwvVJiGqyog070Nm73owwfrAehVJV5EK9sagLn9GIoxv/cSbXPuu7qYGjJLFmKgPGBgM4rjDHH+8VrqBvRM196qtgo3zYF0SOLqvB6IVY8KsaUBeCNYp/SMg+1wNwPCjV7ZO+06WVmXbHsWaYYt6E=", "061111117", null, "nedim89" },
                    { 8, "Brine o administraciji i svakodnevnom radu fitness centra.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 8, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), "amela@example.com", "Amela", true, null, true, null, null, null, "Amelovic", "eTzH2I7r51DzrMwk0p8t0uP/ZlewRbAnzlUR23G1tgJxgo34eezlG5hlCPdC5DcHnn4XO1KFmyIKXuX2lgPyJA==", "6UR7z40QXCreHaDshUU6GcbwvVJiGqyog070Nm73owwfrAehVJV5EK9sagLn9GIoxv/cSbXPuu7qYGjJLFmKgPGBgM4rjDHH+8VrqBvRM196qtgo3zYF0SOLqvB6IVY8KsaUBeCNYp/SMg+1wNwPCjV7ZO+06WVmXbHsWaYYt6E=", "061111118", null, "amela900" },
                    { 9, "Odgovoran za korisničku podršku i prijem novih članova.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1995, 11, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "tarik@example.com", "Tarik", true, null, true, null, null, null, "Tarikovic", "eTzH2I7r51DzrMwk0p8t0uP/ZlewRbAnzlUR23G1tgJxgo34eezlG5hlCPdC5DcHnn4XO1KFmyIKXuX2lgPyJA==", "6UR7z40QXCreHaDshUU6GcbwvVJiGqyog070Nm73owwfrAehVJV5EK9sagLn9GIoxv/cSbXPuu7qYGjJLFmKgPGBgM4rjDHH+8VrqBvRM196qtgo3zYF0SOLqvB6IVY8KsaUBeCNYp/SMg+1wNwPCjV7ZO+06WVmXbHsWaYYt6E=", "061111119", null, "tarik345" },
                    { 10, "Koordinira raspored treninga i komunikaciju sa trenerima.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "emina@example.com", "Emina", true, null, true, null, null, null, "Eminovic", "eTzH2I7r51DzrMwk0p8t0uP/ZlewRbAnzlUR23G1tgJxgo34eezlG5hlCPdC5DcHnn4XO1KFmyIKXuX2lgPyJA==", "6UR7z40QXCreHaDshUU6GcbwvVJiGqyog070Nm73owwfrAehVJV5EK9sagLn9GIoxv/cSbXPuu7qYGjJLFmKgPGBgM4rjDHH+8VrqBvRM196qtgo3zYF0SOLqvB6IVY8KsaUBeCNYp/SMg+1wNwPCjV7ZO+06WVmXbHsWaYYt6E=", "061111120", null, "emina112" },
                    { 11, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2000, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), "haris1@example.com", "Haris", true, null, null, null, true, null, "Hasic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111121", null, "haris1" },
                    { 12, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1999, 9, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "denis2@example.com", "Denis", true, null, null, null, true, null, "Denisovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111122", null, "denis2" },
                    { 13, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2001, 2, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "alen3@example.com", "Alen", true, null, null, null, true, null, "Alenovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111123", null, "alen3" },
                    { 14, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 7, 30, 0, 0, 0, 0, DateTimeKind.Unspecified), "kenan4@example.com", "Kenan", true, null, null, null, true, null, "Kenanovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111124", null, "kenan4" },
                    { 15, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 3, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "jasmin5@example.com", "Jasmin", true, null, null, null, true, null, "Jasminovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111125", null, "jasmin5" },
                    { 16, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2002, 10, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), "lejla6@example.com", "Lejla", true, null, null, null, true, null, "Lejlovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111126", null, "lejla6" },
                    { 17, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2001, 5, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "sara7@example.com", "Sara", true, null, null, null, true, null, "Saric", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111127", null, "sara7" },
                    { 18, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1999, 12, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "amina8@example.com", "Amina", true, null, null, null, true, null, "Aminovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111128", null, "amina8" },
                    { 19, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 8, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "emir9@example.com", "Emir", true, null, null, null, true, null, "Emirovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111129", null, "emir9" },
                    { 20, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "nermin10@example.com", "Nermin", true, null, null, null, true, null, "Nerminovic", "mGmmwbvBdIldYklvU2AwvJKMyDNAFzgsibmIag8yOSfqFKw2GG04f0RwsDGae4YTWNOo7McVPTkctgNCuuo+zA==", "Tw9D5J6a7reH7A55TNoPTKch+Zt/FCjBYwYPvpUFJmm0vvOCFt4rKwq55AMiJyn9JciQT2ym/IUcJFDb4khTz50KUGp2ZcbBByGYZYVW0B2b7u0Qu4uXwFjN6qwH5dZkG60F/jGiCCmwlvANlCLar3m5K6m/SgLu9MKE6AvLYIc=", "061111130", null, "nermin10" }
                });

            migrationBuilder.InsertData(
                table: "Members",
                columns: new[] { "Id", "ExpirationDate", "MembershipId", "PaymentDate", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 4, 1, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5614), 1, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5482), 11 },
                    { 2, new DateTime(2026, 5, 31, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5808), 2, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5808), 12 },
                    { 3, new DateTime(2026, 8, 29, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5812), 3, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5811), 13 },
                    { 4, new DateTime(2027, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5813), 4, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5813), 14 },
                    { 5, new DateTime(2026, 2, 25, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5814), 1, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5814), 15 },
                    { 6, new DateTime(2026, 5, 31, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5815), 2, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5815), 16 },
                    { 7, new DateTime(2026, 2, 20, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5817), 3, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5816), 17 },
                    { 8, new DateTime(2026, 2, 25, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5818), 4, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5817), 18 },
                    { 9, new DateTime(2026, 4, 1, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5819), 1, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5819), 19 },
                    { 10, new DateTime(2026, 2, 20, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5820), 2, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(5820), 20 }
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
                columns: new[] { "Id", "CurrentParticipants", "MaxAmountOfParticipants", "Name", "StartDate", "TrainingImage", "UserId" },
                values: new object[,]
                {
                    { 1, 10, 15, "HIIT", new DateTime(2026, 6, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/hiit/600/400", 3 },
                    { 2, 12, 20, "Cardio Blast", new DateTime(2026, 6, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/cardioblast/600/400", 3 },
                    { 3, 14, 18, "CrossFit", new DateTime(2026, 6, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/crossfit/600/400", 4 },
                    { 4, 8, 12, "Yoga Flow", new DateTime(2026, 6, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/yogaflow/600/400", 4 },
                    { 5, 6, 10, "Pilates", new DateTime(2026, 6, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/pilates/600/400", 5 },
                    { 6, 11, 16, "Strength Training", new DateTime(2026, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/strength/600/400", 5 },
                    { 7, 9, 14, "Boxing", new DateTime(2026, 6, 7, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/boxing/600/400", 6 },
                    { 8, 7, 15, "Kickboxing", new DateTime(2026, 6, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/kickboxing/600/400", 6 },
                    { 9, 13, 20, "Morning Fitness", new DateTime(2026, 6, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/morningfitness/600/400", 3 },
                    { 10, 15, 18, "Evening Cardio", new DateTime(2026, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/eveningcardio/600/400", 4 },
                    { 11, 10, 17, "Body Pump", new DateTime(2026, 6, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/bodypump/600/400", 5 },
                    { 12, 8, 14, "Functional Training", new DateTime(2026, 6, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/functional/600/400", 6 },
                    { 13, 6, 12, "Stretching", new DateTime(2026, 6, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/stretching/600/400", 3 },
                    { 14, 18, 20, "Bootcamp", new DateTime(2026, 6, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/bootcamp/600/400", 4 },
                    { 15, 9, 15, "Abs Workout", new DateTime(2026, 6, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/absworkout/600/400", 5 },
                    { 16, 5, 10, "Powerlifting", new DateTime(2026, 6, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/powerlifting/600/400", 6 },
                    { 17, 14, 20, "Zumba", new DateTime(2026, 6, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/zumba/600/400", 3 },
                    { 18, 12, 18, "Aerobics", new DateTime(2026, 6, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/aerobics/600/400", 4 },
                    { 19, 11, 16, "Circuit Training", new DateTime(2026, 6, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/circuit/600/400", 5 },
                    { 20, 10, 15, "Core Workout", new DateTime(2026, 6, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/core/600/400", 6 }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3317), 2, 1 },
                    { 2, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3704), 2, 2 },
                    { 3, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3705), 3, 3 },
                    { 4, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3706), 3, 4 },
                    { 5, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3706), 3, 5 },
                    { 6, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3707), 3, 6 },
                    { 7, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3708), 4, 7 },
                    { 8, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3708), 4, 8 },
                    { 9, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3709), 4, 9 },
                    { 10, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3710), 4, 10 },
                    { 11, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3710), 1, 11 },
                    { 12, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3711), 1, 12 },
                    { 13, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3712), 1, 13 },
                    { 14, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3712), 1, 14 },
                    { 15, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3713), 1, 15 },
                    { 16, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3713), 1, 16 },
                    { 17, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3714), 1, 17 },
                    { 18, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3715), 1, 18 },
                    { 19, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3715), 1, 19 },
                    { 20, new DateTime(2026, 3, 2, 23, 42, 42, 503, DateTimeKind.Utc).AddTicks(3732), 1, 20 }
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
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "WorkerTasks");

            migrationBuilder.DropTable(
                name: "Memberships");

            migrationBuilder.DropTable(
                name: "Trainings");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
