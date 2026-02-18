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
                    { 1, new DateTime(2026, 2, 18, 1, 44, 30, 88, DateTimeKind.Utc).AddTicks(1292), "", true, "Korisnik" },
                    { 2, new DateTime(2026, 2, 18, 1, 44, 30, 88, DateTimeKind.Utc).AddTicks(1914), "", true, "Admin" },
                    { 3, new DateTime(2026, 2, 18, 1, 44, 30, 88, DateTimeKind.Utc).AddTicks(1917), "", true, "Trener" },
                    { 4, new DateTime(2026, 2, 18, 1, 44, 30, 88, DateTimeKind.Utc).AddTicks(1918), "", true, "Radnik" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "DateOfBirth", "Email", "FirstName", "IsActive", "IsAdmin", "IsRadnik", "IsTrener", "IsUser", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "UserImage", "Username" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(7746), null, "ajdin@example.com", "Tarik", true, true, null, null, null, null, "Malic", "FXW6xdl3aaE1jYo6wCUlQIArhMdEaiTI500l8L/hwfEpmm+URvNEyWLlK7EV9xNWC4ftJW3K3Fy7VO4E+a6YmA==", "ytUPqipoh2AKth+Bn1z+OkLX8og7NNI1iCiokaCHlX8aHMmcKcnPX6u4oNsSu7c3/Nca2QOK53ik74Na2pHVfaFy/Za4KGl8OHIW1R/I8qfyLz3/f6vaTZYooLdY/CKgSKb5q8ip92QbZv/cM/B5n57OUJ42+8dOW9lv0wyOmAU=", null, null, "tare45" },
                    { 2, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8304), null, "amir@example.com", "Amir", true, true, null, null, null, null, "Ibrahimovic", "FXW6xdl3aaE1jYo6wCUlQIArhMdEaiTI500l8L/hwfEpmm+URvNEyWLlK7EV9xNWC4ftJW3K3Fy7VO4E+a6YmA==", "ytUPqipoh2AKth+Bn1z+OkLX8og7NNI1iCiokaCHlX8aHMmcKcnPX6u4oNsSu7c3/Nca2QOK53ik74Na2pHVfaFy/Za4KGl8OHIW1R/I8qfyLz3/f6vaTZYooLdY/CKgSKb5q8ip92QbZv/cM/B5n57OUJ42+8dOW9lv0wyOmAU=", null, null, "amir56" },
                    { 3, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8470), null, "marko@example.com", "Marko", true, null, null, true, null, null, "Markovic", "3Sd+eFRuhomQN9ML0N+JL1ueIkeHzqym72mdTSjYpaNfW2mMV8MTMYUnIF/cn/XOjJvPSkhb72jFxK9TR1BOcg==", "jADgItgKGzShZTDJ/GibUgzsov4Q76rIFC+MGq+M91a9aXvW6cCx/UHlXLUSvGIzIYw+pEu/JFSwkKP574kaqXyGeiDeuIE6hBEig2/umm+m6KErnqgiScIJDdyB6GuDBgYl+TkNQHelOigh/NLQXdqmedAZJOrVNNSl4bZqdrU=", null, null, "marko78" },
                    { 4, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8475), null, "ivan@example.com", "Ivan", true, null, null, true, null, null, "Ivic", "3Sd+eFRuhomQN9ML0N+JL1ueIkeHzqym72mdTSjYpaNfW2mMV8MTMYUnIF/cn/XOjJvPSkhb72jFxK9TR1BOcg==", "jADgItgKGzShZTDJ/GibUgzsov4Q76rIFC+MGq+M91a9aXvW6cCx/UHlXLUSvGIzIYw+pEu/JFSwkKP574kaqXyGeiDeuIE6hBEig2/umm+m6KErnqgiScIJDdyB6GuDBgYl+TkNQHelOigh/NLQXdqmedAZJOrVNNSl4bZqdrU=", null, null, "ivan11" },
                    { 5, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8660), null, "petar@example.com", "Petar", true, null, null, true, null, null, "Petrovic", "3Sd+eFRuhomQN9ML0N+JL1ueIkeHzqym72mdTSjYpaNfW2mMV8MTMYUnIF/cn/XOjJvPSkhb72jFxK9TR1BOcg==", "jADgItgKGzShZTDJ/GibUgzsov4Q76rIFC+MGq+M91a9aXvW6cCx/UHlXLUSvGIzIYw+pEu/JFSwkKP574kaqXyGeiDeuIE6hBEig2/umm+m6KErnqgiScIJDdyB6GuDBgYl+TkNQHelOigh/NLQXdqmedAZJOrVNNSl4bZqdrU=", null, null, "petar21" },
                    { 6, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8663), null, "luka@example.com", "Luka", true, null, null, true, null, null, "Lukic", "3Sd+eFRuhomQN9ML0N+JL1ueIkeHzqym72mdTSjYpaNfW2mMV8MTMYUnIF/cn/XOjJvPSkhb72jFxK9TR1BOcg==", "jADgItgKGzShZTDJ/GibUgzsov4Q76rIFC+MGq+M91a9aXvW6cCx/UHlXLUSvGIzIYw+pEu/JFSwkKP574kaqXyGeiDeuIE6hBEig2/umm+m6KErnqgiScIJDdyB6GuDBgYl+TkNQHelOigh/NLQXdqmedAZJOrVNNSl4bZqdrU=", null, null, "luka34" },
                    { 7, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8889), null, "nedim@example.com", "Nedim", true, null, true, null, null, null, "Nedimovic", "17QmPgtlSuQCX2ZK7f3w4ut/lS7FnQxinwAUn2j5KMlkOUmvdoXuw5UNbDZQ6OTfBvykL7XPHPCROsq7ZdRdGw==", "N7rug9AQzZC3YOWtnaGP7HE2AR294lUK07ljicLU/dCIz4n6q+y2r1j8THNLVmj5UWwp6geRu81SfDRZHhpLC8EsWcTjFtv6IJq5AyyLbE3TY2A2A5w1/MdSMifln0E43NnY36CMXynJQm9RyTfLi3siIJBu0xTq5QTTRc2S6dM=", null, null, "nedim89" },
                    { 8, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8894), null, "amela@example.com", "Amela", true, null, true, null, null, null, "Amelovic", "17QmPgtlSuQCX2ZK7f3w4ut/lS7FnQxinwAUn2j5KMlkOUmvdoXuw5UNbDZQ6OTfBvykL7XPHPCROsq7ZdRdGw==", "N7rug9AQzZC3YOWtnaGP7HE2AR294lUK07ljicLU/dCIz4n6q+y2r1j8THNLVmj5UWwp6geRu81SfDRZHhpLC8EsWcTjFtv6IJq5AyyLbE3TY2A2A5w1/MdSMifln0E43NnY36CMXynJQm9RyTfLi3siIJBu0xTq5QTTRc2S6dM=", null, null, "amela900" },
                    { 9, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8896), null, "tarik@example.com", "Tarik", true, null, true, null, null, null, "Tarikovic", "17QmPgtlSuQCX2ZK7f3w4ut/lS7FnQxinwAUn2j5KMlkOUmvdoXuw5UNbDZQ6OTfBvykL7XPHPCROsq7ZdRdGw==", "N7rug9AQzZC3YOWtnaGP7HE2AR294lUK07ljicLU/dCIz4n6q+y2r1j8THNLVmj5UWwp6geRu81SfDRZHhpLC8EsWcTjFtv6IJq5AyyLbE3TY2A2A5w1/MdSMifln0E43NnY36CMXynJQm9RyTfLi3siIJBu0xTq5QTTRc2S6dM=", null, null, "tarik345" },
                    { 10, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(8931), null, "emina@example.com", "Emina", true, null, true, null, null, null, "Eminovic", "17QmPgtlSuQCX2ZK7f3w4ut/lS7FnQxinwAUn2j5KMlkOUmvdoXuw5UNbDZQ6OTfBvykL7XPHPCROsq7ZdRdGw==", "N7rug9AQzZC3YOWtnaGP7HE2AR294lUK07ljicLU/dCIz4n6q+y2r1j8THNLVmj5UWwp6geRu81SfDRZHhpLC8EsWcTjFtv6IJq5AyyLbE3TY2A2A5w1/MdSMifln0E43NnY36CMXynJQm9RyTfLi3siIJBu0xTq5QTTRc2S6dM=", null, null, "emina112" },
                    { 11, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9084), null, "haris1@example.com", "Haris", true, null, null, null, true, null, "Hasic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "haris1" },
                    { 12, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9088), null, "denis2@example.com", "Denis", true, null, null, null, true, null, "Denisovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "denis2" },
                    { 13, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9091), null, "alen3@example.com", "Alen", true, null, null, null, true, null, "Alenovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "alen3" },
                    { 14, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9093), null, "kenan4@example.com", "Kenan", true, null, null, null, true, null, "Kenanovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "kenan4" },
                    { 15, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9111), null, "jasmin5@example.com", "Jasmin", true, null, null, null, true, null, "Jasminovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "jasmin5" },
                    { 16, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9114), null, "lejla6@example.com", "Lejla", true, null, null, null, true, null, "Lejlovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "lejla6" },
                    { 17, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9117), null, "sara7@example.com", "Sara", true, null, null, null, true, null, "Saric", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "sara7" },
                    { 18, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9119), null, "amina8@example.com", "Amina", true, null, null, null, true, null, "Aminovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "amina8" },
                    { 19, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9121), null, "emir9@example.com", "Emir", true, null, null, null, true, null, "Emirovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "emir9" },
                    { 20, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9124), null, "nermin10@example.com", "Nermin", true, null, null, null, true, null, "Nerminovic", "0wKecZ0r2dUvMUwIDdCa7bNMxrc32W5c+eKP8h2Gto1W/quX+uuSik9D+n/MPsoL/ia1gK3n809/p2Nz6r285Q==", "ikXPdW1EPI2uW+hem/RH50gKXYeixtvl2QWTBw/AuKoGeBbh+YwGknzXm8y6rILkd0WTCOz6oIT1XP1mBnyjDTggWlyraf/3eSD+bZpHc+7aYzaOCc9l0mDOuNlmDOgBBx++uImTlqJR+iRA+Lktho62QLy+xPgc8z81qzRNZLo=", null, null, "nermin10" }
                });

            migrationBuilder.InsertData(
                table: "Members",
                columns: new[] { "Id", "ExpirationDate", "MembershipId", "PaymentDate", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 20, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3184), 1, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(2920), 11 },
                    { 2, new DateTime(2026, 5, 19, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3453), 2, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3453), 12 },
                    { 3, new DateTime(2026, 8, 17, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3457), 3, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3457), 13 },
                    { 4, new DateTime(2027, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3459), 4, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3459), 14 },
                    { 5, new DateTime(2026, 3, 20, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3461), 1, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3460), 15 },
                    { 6, new DateTime(2026, 5, 19, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3462), 2, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3462), 16 },
                    { 7, new DateTime(2026, 8, 17, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3464), 3, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3464), 17 },
                    { 8, new DateTime(2027, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3466), 4, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3465), 18 },
                    { 9, new DateTime(2026, 3, 20, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3467), 1, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3467), 19 },
                    { 10, new DateTime(2026, 5, 19, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3469), 2, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(3468), 20 }
                });

            migrationBuilder.InsertData(
                table: "Trainings",
                columns: new[] { "Id", "CurrentParticipants", "MaxAmountOfParticipants", "Name", "StartDate", "UserId" },
                values: new object[,]
                {
                    { 1, 10, 15, "HIIT", new DateTime(2026, 2, 19, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4548), 3 },
                    { 2, 12, 20, "Cardio Blast", new DateTime(2026, 2, 20, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4791), 3 },
                    { 3, 14, 18, "CrossFit", new DateTime(2026, 2, 21, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4792), 4 },
                    { 4, 8, 12, "Yoga Flow", new DateTime(2026, 2, 22, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4805), 4 },
                    { 5, 6, 10, "Pilates", new DateTime(2026, 2, 23, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4806), 5 },
                    { 6, 11, 16, "Strength Training", new DateTime(2026, 2, 24, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4808), 5 },
                    { 7, 9, 14, "Boxing", new DateTime(2026, 2, 25, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4809), 6 },
                    { 8, 7, 15, "Kickboxing", new DateTime(2026, 2, 26, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4811), 6 },
                    { 9, 13, 20, "Morning Fitness", new DateTime(2026, 2, 27, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4813), 3 },
                    { 10, 15, 18, "Evening Cardio", new DateTime(2026, 2, 28, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4814), 4 },
                    { 11, 10, 17, "Body Pump", new DateTime(2026, 3, 1, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4816), 5 },
                    { 12, 8, 14, "Functional Training", new DateTime(2026, 3, 2, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4817), 6 },
                    { 13, 6, 12, "Stretching", new DateTime(2026, 3, 3, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4819), 3 },
                    { 14, 18, 20, "Bootcamp", new DateTime(2026, 3, 4, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4820), 4 },
                    { 15, 9, 15, "Abs Workout", new DateTime(2026, 3, 5, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4822), 5 },
                    { 16, 5, 10, "Powerlifting", new DateTime(2026, 3, 6, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4823), 6 },
                    { 17, 14, 20, "Zumba", new DateTime(2026, 3, 7, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4825), 3 },
                    { 18, 12, 18, "Aerobics", new DateTime(2026, 3, 8, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4826), 4 },
                    { 19, 11, 16, "Circuit Training", new DateTime(2026, 3, 9, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4828), 5 },
                    { 20, 10, 15, "Core Workout", new DateTime(2026, 3, 10, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(4829), 6 }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 18, 1, 44, 30, 97, DateTimeKind.Utc).AddTicks(9949), 2, 1 },
                    { 2, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(594), 2, 2 },
                    { 3, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(596), 3, 3 },
                    { 4, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(597), 3, 4 },
                    { 5, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(598), 3, 5 },
                    { 6, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(599), 3, 6 },
                    { 7, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(600), 4, 7 },
                    { 8, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(600), 4, 8 },
                    { 9, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(601), 4, 9 },
                    { 10, new DateTime(2026, 2, 18, 1, 44, 30, 98, DateTimeKind.Utc).AddTicks(602), 4, 10 }
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
