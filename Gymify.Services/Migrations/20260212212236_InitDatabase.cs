using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Gymify.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitDatabase : Migration
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
                    DurationInDays = table.Column<int>(type: "int", nullable: false),
                    Detaisl = table.Column<string>(type: "nvarchar(max)", nullable: false)
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
                table: "Roles",
                columns: new[] { "Id", "CreatedAt", "Description", "IsActive", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 12, 21, 22, 35, 759, DateTimeKind.Utc).AddTicks(46), "", true, "Korisnik" },
                    { 2, new DateTime(2026, 2, 12, 21, 22, 35, 759, DateTimeKind.Utc).AddTicks(500), "", true, "Admin" },
                    { 3, new DateTime(2026, 2, 12, 21, 22, 35, 759, DateTimeKind.Utc).AddTicks(502), "", true, "Trener" },
                    { 4, new DateTime(2026, 2, 12, 21, 22, 35, 759, DateTimeKind.Utc).AddTicks(503), "", true, "Radnik" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "DateOfBirth", "Email", "FirstName", "IsActive", "IsAdmin", "IsRadnik", "IsTrener", "IsUser", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "UserImage", "Username" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(4473), null, "ajdin@example.com", "Tarik", true, true, null, null, null, null, "Malic", "Zr1yNL0PufElmoWUKiywJXZiR9ph00sz67ucqetSNOqEGdxODG4plmzu/jquyPnS+9BxZIb3y9h5EaQQJUVOPw==", "i3sFkRAERrTgIDIz5MbXP6B5cyYSqTD7DOpOhq1zurYgCJn3BjA1SpE/a9Qv1huFaH57SteTbaA2uId7c4/o7+n5VDXnEb/Y7I/am9LrKOQGeOSdrSg/cgUBf/L6Mw8wlWWiSij7iMUw5zW4zExKzwYLpi2Y28x/0lJotdYvfSA=", null, null, "tare45" },
                    { 2, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(4916), null, "amir@example.com", "Amir", true, true, null, null, null, null, "Ibrahimovic", "Zr1yNL0PufElmoWUKiywJXZiR9ph00sz67ucqetSNOqEGdxODG4plmzu/jquyPnS+9BxZIb3y9h5EaQQJUVOPw==", "i3sFkRAERrTgIDIz5MbXP6B5cyYSqTD7DOpOhq1zurYgCJn3BjA1SpE/a9Qv1huFaH57SteTbaA2uId7c4/o7+n5VDXnEb/Y7I/am9LrKOQGeOSdrSg/cgUBf/L6Mw8wlWWiSij7iMUw5zW4zExKzwYLpi2Y28x/0lJotdYvfSA=", null, null, "amir56" },
                    { 3, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5052), null, "marko@example.com", "Marko", true, null, null, true, null, null, "Markovic", "rf+iRBC3+Or3QUIDpDUuoHiS88jzJ5YEpvK/eiNLPouKobVrWctIAYyzIUoL0++XIDsaqFXuSUgGtv5K20MiPg==", "/P1/X5G5cYEYmWouZSL7au0ZJ9pvffTAes5jpZK1ShVOUu1WJNxiZGIz9mV/zfAhLU2HDrxhxlRdU5ISmEBcu5GC7/sUiq3+fGzZRrxaBVNO4cFpNJND+XA/k5NHykxwYCN7PqX3+a2/O3sj4Vg7ef9G786TCT5vVRqJsoCC70w=", null, null, "marko78" },
                    { 4, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5056), null, "ivan@example.com", "Ivan", true, null, null, true, null, null, "Ivic", "rf+iRBC3+Or3QUIDpDUuoHiS88jzJ5YEpvK/eiNLPouKobVrWctIAYyzIUoL0++XIDsaqFXuSUgGtv5K20MiPg==", "/P1/X5G5cYEYmWouZSL7au0ZJ9pvffTAes5jpZK1ShVOUu1WJNxiZGIz9mV/zfAhLU2HDrxhxlRdU5ISmEBcu5GC7/sUiq3+fGzZRrxaBVNO4cFpNJND+XA/k5NHykxwYCN7PqX3+a2/O3sj4Vg7ef9G786TCT5vVRqJsoCC70w=", null, null, "ivan11" },
                    { 5, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5058), null, "petar@example.com", "Petar", true, null, null, true, null, null, "Petrovic", "rf+iRBC3+Or3QUIDpDUuoHiS88jzJ5YEpvK/eiNLPouKobVrWctIAYyzIUoL0++XIDsaqFXuSUgGtv5K20MiPg==", "/P1/X5G5cYEYmWouZSL7au0ZJ9pvffTAes5jpZK1ShVOUu1WJNxiZGIz9mV/zfAhLU2HDrxhxlRdU5ISmEBcu5GC7/sUiq3+fGzZRrxaBVNO4cFpNJND+XA/k5NHykxwYCN7PqX3+a2/O3sj4Vg7ef9G786TCT5vVRqJsoCC70w=", null, null, "petar21" },
                    { 6, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5060), null, "luka@example.com", "Luka", true, null, null, true, null, null, "Lukic", "rf+iRBC3+Or3QUIDpDUuoHiS88jzJ5YEpvK/eiNLPouKobVrWctIAYyzIUoL0++XIDsaqFXuSUgGtv5K20MiPg==", "/P1/X5G5cYEYmWouZSL7au0ZJ9pvffTAes5jpZK1ShVOUu1WJNxiZGIz9mV/zfAhLU2HDrxhxlRdU5ISmEBcu5GC7/sUiq3+fGzZRrxaBVNO4cFpNJND+XA/k5NHykxwYCN7PqX3+a2/O3sj4Vg7ef9G786TCT5vVRqJsoCC70w=", null, null, "luka34" },
                    { 7, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5194), null, "nedim@example.com", "Nedim", true, null, true, null, null, null, "Nedimovic", "WFiLOJuHLZNlNwIn/7JPsZRWwSbX9d4WOPZfrudDIMCzL+yrSoIUGfflS6Nb6O159An87pMC/7xgTXcvC+bXug==", "xa7tCyzbFr4FJ8QeeJa47dDbRHC2u+F57iwgrlipKAH/5Y9huunkmoy2yQdjxhoDSEDfgp2dbyU91v8/lPmtL1nDy2OpOMQc+86Z3TfatN7J6szK0qSLYb/VjlG3tKaSrVN6cpmBdF5D777aVOyBlf+D+vxBEpeGXUZfOG4jYUM=", null, null, "nedim89" },
                    { 8, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5197), null, "amela@example.com", "Amela", true, null, true, null, null, null, "Amelovic", "WFiLOJuHLZNlNwIn/7JPsZRWwSbX9d4WOPZfrudDIMCzL+yrSoIUGfflS6Nb6O159An87pMC/7xgTXcvC+bXug==", "xa7tCyzbFr4FJ8QeeJa47dDbRHC2u+F57iwgrlipKAH/5Y9huunkmoy2yQdjxhoDSEDfgp2dbyU91v8/lPmtL1nDy2OpOMQc+86Z3TfatN7J6szK0qSLYb/VjlG3tKaSrVN6cpmBdF5D777aVOyBlf+D+vxBEpeGXUZfOG4jYUM=", null, null, "amela900" },
                    { 9, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5199), null, "tarik@example.com", "Tarik", true, null, true, null, null, null, "Tarikovic", "WFiLOJuHLZNlNwIn/7JPsZRWwSbX9d4WOPZfrudDIMCzL+yrSoIUGfflS6Nb6O159An87pMC/7xgTXcvC+bXug==", "xa7tCyzbFr4FJ8QeeJa47dDbRHC2u+F57iwgrlipKAH/5Y9huunkmoy2yQdjxhoDSEDfgp2dbyU91v8/lPmtL1nDy2OpOMQc+86Z3TfatN7J6szK0qSLYb/VjlG3tKaSrVN6cpmBdF5D777aVOyBlf+D+vxBEpeGXUZfOG4jYUM=", null, null, "tarik345" },
                    { 10, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5201), null, "emina@example.com", "Emina", true, null, true, null, null, null, "Eminovic", "WFiLOJuHLZNlNwIn/7JPsZRWwSbX9d4WOPZfrudDIMCzL+yrSoIUGfflS6Nb6O159An87pMC/7xgTXcvC+bXug==", "xa7tCyzbFr4FJ8QeeJa47dDbRHC2u+F57iwgrlipKAH/5Y9huunkmoy2yQdjxhoDSEDfgp2dbyU91v8/lPmtL1nDy2OpOMQc+86Z3TfatN7J6szK0qSLYb/VjlG3tKaSrVN6cpmBdF5D777aVOyBlf+D+vxBEpeGXUZfOG4jYUM=", null, null, "emina112" }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(5877), 2, 1 },
                    { 2, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6337), 2, 2 },
                    { 3, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6338), 3, 3 },
                    { 4, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6339), 3, 4 },
                    { 5, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6340), 3, 5 },
                    { 6, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6341), 3, 6 },
                    { 7, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6342), 4, 7 },
                    { 8, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6342), 4, 8 },
                    { 9, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6381), 4, 9 },
                    { 10, new DateTime(2026, 2, 12, 21, 22, 35, 764, DateTimeKind.Utc).AddTicks(6382), 4, 10 }
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
