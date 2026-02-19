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
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "WorkerTasks",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Details = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedTaskDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ExparationTaskDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsFinished = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkerTasks", x => x.Id);
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
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
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
                    { 1, new DateTime(2026, 2, 19, 14, 33, 33, 770, DateTimeKind.Utc).AddTicks(8496), "", true, "Korisnik" },
                    { 2, new DateTime(2026, 2, 19, 14, 33, 33, 770, DateTimeKind.Utc).AddTicks(9058), "", true, "Admin" },
                    { 3, new DateTime(2026, 2, 19, 14, 33, 33, 770, DateTimeKind.Utc).AddTicks(9060), "", true, "Trener" },
                    { 4, new DateTime(2026, 2, 19, 14, 33, 33, 770, DateTimeKind.Utc).AddTicks(9061), "", true, "Radnik" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "DateOfBirth", "Email", "FirstName", "IsActive", "IsAdmin", "IsRadnik", "IsTrener", "IsUser", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "UserImage", "Username" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(683), null, "ajdin@example.com", "Tarik", true, true, null, null, null, null, "Malic", "PUarWGVwtrqAleOzGsMUVdbKWFadEyS5YiDwH5LeCeroo/RoBDhrzhgfsErmyiPnQpkK2Yx8zWmUZblnTzOuHg==", "u8Y5VIHf3kBmwxA7QM42iYHHQwBAseR3v1i/h4OO1TLUDDuMlIe60EFz40kttLDdFmoly67voIaVsYN89BIMqKRGfOpV8hC6Op24LSgK7+C6GB1fVREM8v/eLMrACiQuyZ7bTgBxLb5szQDYnsC52PDV/rOOOu86X/fpdhG8zio=", null, null, "tare45" },
                    { 2, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1287), null, "amir@example.com", "Amir", true, true, null, null, null, null, "Ibrahimovic", "PUarWGVwtrqAleOzGsMUVdbKWFadEyS5YiDwH5LeCeroo/RoBDhrzhgfsErmyiPnQpkK2Yx8zWmUZblnTzOuHg==", "u8Y5VIHf3kBmwxA7QM42iYHHQwBAseR3v1i/h4OO1TLUDDuMlIe60EFz40kttLDdFmoly67voIaVsYN89BIMqKRGfOpV8hC6Op24LSgK7+C6GB1fVREM8v/eLMrACiQuyZ7bTgBxLb5szQDYnsC52PDV/rOOOu86X/fpdhG8zio=", null, null, "amir56" },
                    { 3, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1500), null, "marko@example.com", "Marko", true, null, null, true, null, null, "Markovic", "9XnDxbdrANcy+R5lFHcX9ikVwHKAPQsY6bN1IullQQTRXD7Mee8Yzp0VETUyN/LKuYW+nIkLTrvwL1AzmWAcPw==", "rO+lalEcZqQnL3in8eHY3on3fknw9Lz0l05dbi0xXlT/CvKmFf69RVSMPzybCOwdZJfxxXIDyoJgrUGjXEQDIj9e5PQV1q94OCVmHgGMQ9Oovz5QH0Lst2Ue+JLQS27kRq8qZ+KNMeFC8BiBoPsp1y+q203J+KYnwxo+JKLBmqM=", null, null, "marko78" },
                    { 4, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1505), null, "ivan@example.com", "Ivan", true, null, null, true, null, null, "Ivic", "9XnDxbdrANcy+R5lFHcX9ikVwHKAPQsY6bN1IullQQTRXD7Mee8Yzp0VETUyN/LKuYW+nIkLTrvwL1AzmWAcPw==", "rO+lalEcZqQnL3in8eHY3on3fknw9Lz0l05dbi0xXlT/CvKmFf69RVSMPzybCOwdZJfxxXIDyoJgrUGjXEQDIj9e5PQV1q94OCVmHgGMQ9Oovz5QH0Lst2Ue+JLQS27kRq8qZ+KNMeFC8BiBoPsp1y+q203J+KYnwxo+JKLBmqM=", null, null, "ivan11" },
                    { 5, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1522), null, "petar@example.com", "Petar", true, null, null, true, null, null, "Petrovic", "9XnDxbdrANcy+R5lFHcX9ikVwHKAPQsY6bN1IullQQTRXD7Mee8Yzp0VETUyN/LKuYW+nIkLTrvwL1AzmWAcPw==", "rO+lalEcZqQnL3in8eHY3on3fknw9Lz0l05dbi0xXlT/CvKmFf69RVSMPzybCOwdZJfxxXIDyoJgrUGjXEQDIj9e5PQV1q94OCVmHgGMQ9Oovz5QH0Lst2Ue+JLQS27kRq8qZ+KNMeFC8BiBoPsp1y+q203J+KYnwxo+JKLBmqM=", null, null, "petar21" },
                    { 6, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1525), null, "luka@example.com", "Luka", true, null, null, true, null, null, "Lukic", "9XnDxbdrANcy+R5lFHcX9ikVwHKAPQsY6bN1IullQQTRXD7Mee8Yzp0VETUyN/LKuYW+nIkLTrvwL1AzmWAcPw==", "rO+lalEcZqQnL3in8eHY3on3fknw9Lz0l05dbi0xXlT/CvKmFf69RVSMPzybCOwdZJfxxXIDyoJgrUGjXEQDIj9e5PQV1q94OCVmHgGMQ9Oovz5QH0Lst2Ue+JLQS27kRq8qZ+KNMeFC8BiBoPsp1y+q203J+KYnwxo+JKLBmqM=", null, null, "luka34" },
                    { 7, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1678), null, "nedim@example.com", "Nedim", true, null, true, null, null, null, "Nedimovic", "RLEq7oUSL7vo0HZEMYrAnsy0UQUk5tVAsv60UsLjVkkzMQkd4+Vo4lSQ+vzBIbFXY9wRSJaeDhW+PNm6SITXKw==", "BOo1BkQhCHJP4Xlo0Trx8Ftj2Y88WYqpF24Eu0WHo3QW4EVwifBM9VZZIvY9Z5BrnQsoELOIlmzA8O9MeHGiS0QcNGXJAMGk4scO/tJysqLt598OIXcjiYRmR9yXNl8DjaSR8PgAsfGT9bg4HTv+Vt1uPHvc3ULAuZNi3jj5jDk=", null, null, "nedim89" },
                    { 8, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1682), null, "amela@example.com", "Amela", true, null, true, null, null, null, "Amelovic", "RLEq7oUSL7vo0HZEMYrAnsy0UQUk5tVAsv60UsLjVkkzMQkd4+Vo4lSQ+vzBIbFXY9wRSJaeDhW+PNm6SITXKw==", "BOo1BkQhCHJP4Xlo0Trx8Ftj2Y88WYqpF24Eu0WHo3QW4EVwifBM9VZZIvY9Z5BrnQsoELOIlmzA8O9MeHGiS0QcNGXJAMGk4scO/tJysqLt598OIXcjiYRmR9yXNl8DjaSR8PgAsfGT9bg4HTv+Vt1uPHvc3ULAuZNi3jj5jDk=", null, null, "amela900" },
                    { 9, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1684), null, "tarik@example.com", "Tarik", true, null, true, null, null, null, "Tarikovic", "RLEq7oUSL7vo0HZEMYrAnsy0UQUk5tVAsv60UsLjVkkzMQkd4+Vo4lSQ+vzBIbFXY9wRSJaeDhW+PNm6SITXKw==", "BOo1BkQhCHJP4Xlo0Trx8Ftj2Y88WYqpF24Eu0WHo3QW4EVwifBM9VZZIvY9Z5BrnQsoELOIlmzA8O9MeHGiS0QcNGXJAMGk4scO/tJysqLt598OIXcjiYRmR9yXNl8DjaSR8PgAsfGT9bg4HTv+Vt1uPHvc3ULAuZNi3jj5jDk=", null, null, "tarik345" },
                    { 10, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1687), null, "emina@example.com", "Emina", true, null, true, null, null, null, "Eminovic", "RLEq7oUSL7vo0HZEMYrAnsy0UQUk5tVAsv60UsLjVkkzMQkd4+Vo4lSQ+vzBIbFXY9wRSJaeDhW+PNm6SITXKw==", "BOo1BkQhCHJP4Xlo0Trx8Ftj2Y88WYqpF24Eu0WHo3QW4EVwifBM9VZZIvY9Z5BrnQsoELOIlmzA8O9MeHGiS0QcNGXJAMGk4scO/tJysqLt598OIXcjiYRmR9yXNl8DjaSR8PgAsfGT9bg4HTv+Vt1uPHvc3ULAuZNi3jj5jDk=", null, null, "emina112" },
                    { 11, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1836), null, "haris1@example.com", "Haris", true, null, null, null, true, null, "Hasic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "haris1" },
                    { 12, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1840), null, "denis2@example.com", "Denis", true, null, null, null, true, null, "Denisovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "denis2" },
                    { 13, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1843), null, "alen3@example.com", "Alen", true, null, null, null, true, null, "Alenovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "alen3" },
                    { 14, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1845), null, "kenan4@example.com", "Kenan", true, null, null, null, true, null, "Kenanovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "kenan4" },
                    { 15, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1861), null, "jasmin5@example.com", "Jasmin", true, null, null, null, true, null, "Jasminovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "jasmin5" },
                    { 16, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1864), null, "lejla6@example.com", "Lejla", true, null, null, null, true, null, "Lejlovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "lejla6" },
                    { 17, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1866), null, "sara7@example.com", "Sara", true, null, null, null, true, null, "Saric", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "sara7" },
                    { 18, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1870), null, "amina8@example.com", "Amina", true, null, null, null, true, null, "Aminovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "amina8" },
                    { 19, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1872), null, "emir9@example.com", "Emir", true, null, null, null, true, null, "Emirovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "emir9" },
                    { 20, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(1874), null, "nermin10@example.com", "Nermin", true, null, null, null, true, null, "Nerminovic", "T/baD+kO/nwtipCw2/8ZdfejUkAGH50xByQB/+aONVVYvfm1KX1ADdd/Rd9QI8+Pp/u/14F4qXWJH88ij23ToQ==", "3mSlFjuScivXUkfoyHsy0yniRoOhOnRTFlQyIRwQxXd8dX8VArjZquXi46BA1cXWcWM0VXC2Gjrse6Bi9RsltmtDFIillSdDsLH8UDgzQs64SswMhCFg48YXId2Wfq3pOobAeCF7BpnWu5y4kWN/MHTVrQwL71ies+NoeGpQGMk=", null, null, "nermin10" }
                });

            migrationBuilder.InsertData(
                table: "Members",
                columns: new[] { "Id", "ExpirationDate", "MembershipId", "PaymentDate", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 21, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5326), 1, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5174), 11 },
                    { 2, new DateTime(2026, 5, 20, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5536), 2, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5535), 12 },
                    { 3, new DateTime(2026, 8, 18, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5540), 3, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5539), 13 },
                    { 4, new DateTime(2027, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5541), 4, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5541), 14 },
                    { 5, new DateTime(2026, 2, 14, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5543), 1, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5543), 15 },
                    { 6, new DateTime(2026, 5, 20, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5545), 2, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5544), 16 },
                    { 7, new DateTime(2026, 2, 9, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5546), 3, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5546), 17 },
                    { 8, new DateTime(2026, 2, 14, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5548), 4, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5547), 18 },
                    { 9, new DateTime(2026, 3, 21, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5549), 1, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5549), 19 },
                    { 10, new DateTime(2026, 2, 9, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5551), 2, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(5551), 20 }
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
                    { 1, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(2609), 2, 1 },
                    { 2, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3073), 2, 2 },
                    { 3, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3074), 3, 3 },
                    { 4, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3075), 3, 4 },
                    { 5, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3076), 3, 5 },
                    { 6, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3077), 3, 6 },
                    { 7, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3078), 4, 7 },
                    { 8, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3079), 4, 8 },
                    { 9, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3080), 4, 9 },
                    { 10, new DateTime(2026, 2, 19, 14, 33, 33, 777, DateTimeKind.Utc).AddTicks(3081), 4, 10 }
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
