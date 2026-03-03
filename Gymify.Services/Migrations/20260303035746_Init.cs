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
                    { 1, new DateTime(2026, 3, 3, 3, 57, 46, 407, DateTimeKind.Utc).AddTicks(8442), "", true, "Korisnik" },
                    { 2, new DateTime(2026, 3, 3, 3, 57, 46, 407, DateTimeKind.Utc).AddTicks(8855), "", true, "Admin" },
                    { 3, new DateTime(2026, 3, 3, 3, 57, 46, 407, DateTimeKind.Utc).AddTicks(8857), "", true, "Trener" },
                    { 4, new DateTime(2026, 3, 3, 3, 57, 46, 407, DateTimeKind.Utc).AddTicks(8858), "", true, "Radnik" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "AboutMe", "CreatedAt", "DateOfBirth", "Email", "FirstName", "IsActive", "IsAdmin", "IsRadnik", "IsTrener", "IsUser", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "UserImage", "Username" },
                values: new object[,]
                {
                    { 1, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1995, 5, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "healthcaretest190@gmail.com", "Tarik", true, true, null, null, null, null, "Malic", "a/ltJ7B7vtcMZhCIzkgBJXCATnneMEFEc3Hgx94v0nGcbFkUX2pthowUrhxC1XSO2U+eLfnj7LFU1IUgNYffug==", "CcnZ27SnBRmidH0pkSukCGrXgDt5//O1hzk6YfwhxQiudnQphUnNz60OQo3ADwZfJnYEG1P4m73ypqwkmywecN4sxYh5p0eAtRsYN6ykzF4xiPz7zr7o+KGLmTRIpvSl97idCk57a7HXfjme/CAWfkTidyafWQLS6awRMuTzYxY=", "061111111", null, "tare45" },
                    { 2, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1994, 3, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), "amir@example.com", "Amir", true, true, null, null, null, null, "Ibrahimovic", "a/ltJ7B7vtcMZhCIzkgBJXCATnneMEFEc3Hgx94v0nGcbFkUX2pthowUrhxC1XSO2U+eLfnj7LFU1IUgNYffug==", "CcnZ27SnBRmidH0pkSukCGrXgDt5//O1hzk6YfwhxQiudnQphUnNz60OQo3ADwZfJnYEG1P4m73ypqwkmywecN4sxYh5p0eAtRsYN6ykzF4xiPz7zr7o+KGLmTRIpvSl97idCk57a7HXfjme/CAWfkTidyafWQLS6awRMuTzYxY=", "061111112", null, "amir56" },
                    { 3, "Licencirani fitness trener sa 5 godina iskustva u radu sa klijentima svih uzrasta.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1990, 7, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), "marko@example.com", "Marko", true, null, null, true, null, null, "Markovic", "NqfMnfO/TvQrSWt7BTlSlGIXiuXbIQFrDD14EHu0l1N/uh6jAtpp/DdUVurizbfI02Z5BS2bhZFVBIwfPwhzXg==", "1bHWJrU96ikBB1lg3+s0+b1oRGQYOCBqkXEim2ax58Lz6CcbEVe1/dKZD+X3eNeHR01nhjsiaXE8MwdjW7vh2tcNxF613HLKBGSKjYgvU5wU/50y0iz/1fUuovvPfk1ostCfmyrNAjtQdJRPkzCKVNQU71WY+kWvZlDtySNuQKc=", "061111113", null, "marko78" },
                    { 4, "Specijalizovan za kondicionu pripremu i izgradnju mišićne mase.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1989, 2, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "ivan@example.com", "Ivan", true, null, null, true, null, null, "Ivic", "NqfMnfO/TvQrSWt7BTlSlGIXiuXbIQFrDD14EHu0l1N/uh6jAtpp/DdUVurizbfI02Z5BS2bhZFVBIwfPwhzXg==", "1bHWJrU96ikBB1lg3+s0+b1oRGQYOCBqkXEim2ax58Lz6CcbEVe1/dKZD+X3eNeHR01nhjsiaXE8MwdjW7vh2tcNxF613HLKBGSKjYgvU5wU/50y0iz/1fUuovvPfk1ostCfmyrNAjtQdJRPkzCKVNQU71WY+kWvZlDtySNuQKc=", "061111114", null, "ivan11" },
                    { 5, "Stručnjak za funkcionalne treninge i planove ishrane.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1992, 9, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "petar@example.com", "Petar", true, null, null, true, null, null, "Petrovic", "NqfMnfO/TvQrSWt7BTlSlGIXiuXbIQFrDD14EHu0l1N/uh6jAtpp/DdUVurizbfI02Z5BS2bhZFVBIwfPwhzXg==", "1bHWJrU96ikBB1lg3+s0+b1oRGQYOCBqkXEim2ax58Lz6CcbEVe1/dKZD+X3eNeHR01nhjsiaXE8MwdjW7vh2tcNxF613HLKBGSKjYgvU5wU/50y0iz/1fUuovvPfk1ostCfmyrNAjtQdJRPkzCKVNQU71WY+kWvZlDtySNuQKc=", "061111115", null, "petar21" },
                    { 6, "Posvećen radu sa početnicima i personalizovanim fitness programima.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1993, 12, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), "luka@example.com", "Luka", true, null, null, true, null, null, "Lukic", "NqfMnfO/TvQrSWt7BTlSlGIXiuXbIQFrDD14EHu0l1N/uh6jAtpp/DdUVurizbfI02Z5BS2bhZFVBIwfPwhzXg==", "1bHWJrU96ikBB1lg3+s0+b1oRGQYOCBqkXEim2ax58Lz6CcbEVe1/dKZD+X3eNeHR01nhjsiaXE8MwdjW7vh2tcNxF613HLKBGSKjYgvU5wU/50y0iz/1fUuovvPfk1ostCfmyrNAjtQdJRPkzCKVNQU71WY+kWvZlDtySNuQKc=", "061111116", null, "luka34" },
                    { 7, "Zadužen za organizaciju termina i podršku članovima teretane.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1996, 4, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "nedim@example.com", "Nedim", true, null, true, null, null, null, "Nedimovic", "NeLI1bzsBtEfLvrvyBiyoAwp/cwe0wNZqTWIfEb4+kzqtW4/JUXtrZdDuC2SjAk1MiTlBj0DoE9Iv9PviAZh+g==", "lWL//ugb+8T/rG16xcttUfa8fLd/OpWJRQYYBxl7tGSWGNlu8oyKOTuWw/9QD+nMt9Sq5VmMirqgJXCVdmI/DX0chz0Qpd+Piz5+yPGabBfBrEGAe0ONQMLl0Z0N1Lafj9MCr0OSsdw2kGwM0OSoSDGqsL4nzDi6GbKuGdaBRBc=", "061111117", null, "nedim89" },
                    { 8, "Brine o administraciji i svakodnevnom radu fitness centra.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 8, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), "amela@example.com", "Amela", true, null, true, null, null, null, "Amelovic", "NeLI1bzsBtEfLvrvyBiyoAwp/cwe0wNZqTWIfEb4+kzqtW4/JUXtrZdDuC2SjAk1MiTlBj0DoE9Iv9PviAZh+g==", "lWL//ugb+8T/rG16xcttUfa8fLd/OpWJRQYYBxl7tGSWGNlu8oyKOTuWw/9QD+nMt9Sq5VmMirqgJXCVdmI/DX0chz0Qpd+Piz5+yPGabBfBrEGAe0ONQMLl0Z0N1Lafj9MCr0OSsdw2kGwM0OSoSDGqsL4nzDi6GbKuGdaBRBc=", "061111118", null, "amela900" },
                    { 9, "Odgovoran za korisničku podršku i prijem novih članova.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1995, 11, 9, 0, 0, 0, 0, DateTimeKind.Unspecified), "tarik@example.com", "Tarik", true, null, true, null, null, null, "Tarikovic", "NeLI1bzsBtEfLvrvyBiyoAwp/cwe0wNZqTWIfEb4+kzqtW4/JUXtrZdDuC2SjAk1MiTlBj0DoE9Iv9PviAZh+g==", "lWL//ugb+8T/rG16xcttUfa8fLd/OpWJRQYYBxl7tGSWGNlu8oyKOTuWw/9QD+nMt9Sq5VmMirqgJXCVdmI/DX0chz0Qpd+Piz5+yPGabBfBrEGAe0ONQMLl0Z0N1Lafj9MCr0OSsdw2kGwM0OSoSDGqsL4nzDi6GbKuGdaBRBc=", "061111119", null, "tarik345" },
                    { 10, "Koordinira raspored treninga i komunikaciju sa trenerima.", new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 1, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "emina@example.com", "Emina", true, null, true, null, null, null, "Eminovic", "NeLI1bzsBtEfLvrvyBiyoAwp/cwe0wNZqTWIfEb4+kzqtW4/JUXtrZdDuC2SjAk1MiTlBj0DoE9Iv9PviAZh+g==", "lWL//ugb+8T/rG16xcttUfa8fLd/OpWJRQYYBxl7tGSWGNlu8oyKOTuWw/9QD+nMt9Sq5VmMirqgJXCVdmI/DX0chz0Qpd+Piz5+yPGabBfBrEGAe0ONQMLl0Z0N1Lafj9MCr0OSsdw2kGwM0OSoSDGqsL4nzDi6GbKuGdaBRBc=", "061111120", null, "emina112" },
                    { 11, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2000, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), "haris1@example.com", "Haris", true, null, null, null, true, null, "Hasic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111121", null, "haris1" },
                    { 12, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1999, 9, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "denis2@example.com", "Denis", true, null, null, null, true, null, "Denisovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111122", null, "denis2" },
                    { 13, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2001, 2, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "alen3@example.com", "Alen", true, null, null, null, true, null, "Alenovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111123", null, "alen3" },
                    { 14, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 7, 30, 0, 0, 0, 0, DateTimeKind.Unspecified), "kenan4@example.com", "Kenan", true, null, null, null, true, null, "Kenanovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111124", null, "kenan4" },
                    { 15, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 3, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "jasmin5@example.com", "Jasmin", true, null, null, null, true, null, "Jasminovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111125", null, "jasmin5" },
                    { 16, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2002, 10, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), "lejla6@example.com", "Lejla", true, null, null, null, true, null, "Lejlovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111126", null, "lejla6" },
                    { 17, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2001, 5, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "sara7@example.com", "Sara", true, null, null, null, true, null, "Saric", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111127", null, "sara7" },
                    { 18, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1999, 12, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "amina8@example.com", "Amina", true, null, null, null, true, null, "Aminovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111128", null, "amina8" },
                    { 19, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1998, 8, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "emir9@example.com", "Emir", true, null, null, null, true, null, "Emirovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111129", null, "emir9" },
                    { 20, null, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(1997, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "nermin10@example.com", "Nermin", true, null, null, null, true, null, "Nerminovic", "MXdbK5opJla0Z/g5ooMWC0q1YjuHdHgRJ2gz/1B39WFEN9Vz12gLMp+f1d/4+eLCZpgOdpilzDqOiYB/FLrLoQ==", "QizuJj4FZxWkWzcb9akyUsJir5SJUljCGIyiWZg1SqBXrIBo1mgL13jZ3sQsNsiLsNh8HPrH1+zH6JPXBhgDb5gY95Dyq+MrpgxKZXZ+65Q2CqgcGfMta+gmkwFU++y/xgIA9tjItMZqAmhWFPzodD6DROnApc/8txerKBLTsqY=", "061111130", null, "nermin10" }
                });

            migrationBuilder.InsertData(
                table: "Members",
                columns: new[] { "Id", "ExpirationDate", "MembershipId", "PaymentDate", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 2, 28, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1062), 2, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(900), 11 },
                    { 2, new DateTime(2026, 6, 1, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1318), 2, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1318), 12 },
                    { 3, new DateTime(2026, 8, 30, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1323), 3, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1322), 13 },
                    { 4, new DateTime(2027, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1324), 4, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1324), 14 },
                    { 5, new DateTime(2026, 2, 26, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1326), 1, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1326), 15 },
                    { 6, new DateTime(2026, 6, 1, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1327), 2, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1327), 16 },
                    { 7, new DateTime(2026, 2, 21, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1350), 3, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1350), 17 },
                    { 8, new DateTime(2026, 2, 26, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1351), 4, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1351), 18 },
                    { 9, new DateTime(2026, 4, 2, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1353), 1, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1352), 19 },
                    { 10, new DateTime(2026, 2, 21, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1354), 2, new DateTime(2026, 3, 3, 3, 57, 46, 414, DateTimeKind.Utc).AddTicks(1354), 20 }
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
                    { 20, 10, 15, "Core Workout", new DateTime(2026, 6, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/core/600/400", 6 },
                    { 21, 11, 15, "HIIT (Feb)", new DateTime(2026, 2, 10, 18, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/hiitfeb/600/400", 3 },
                    { 22, 9, 12, "Yoga Flow (Feb)", new DateTime(2026, 2, 14, 19, 30, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/yogafeb/600/400", 4 },
                    { 23, 13, 16, "Strength Training (Feb)", new DateTime(2026, 2, 20, 17, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/strengthfeb/600/400", 5 },
                    { 24, 10, 14, "Boxing (Feb)", new DateTime(2026, 2, 25, 20, 0, 0, 0, DateTimeKind.Unspecified), "https://picsum.photos/seed/boxingfeb/600/400", 6 }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8036), 2, 1 },
                    { 2, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8518), 2, 2 },
                    { 3, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8520), 3, 3 },
                    { 4, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8520), 3, 4 },
                    { 5, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8521), 3, 5 },
                    { 6, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8522), 3, 6 },
                    { 7, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8523), 4, 7 },
                    { 8, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8524), 4, 8 },
                    { 9, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8525), 4, 9 },
                    { 10, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8551), 4, 10 },
                    { 11, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8552), 1, 11 },
                    { 12, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8553), 1, 12 },
                    { 13, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8586), 1, 13 },
                    { 14, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8587), 1, 14 },
                    { 15, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8588), 1, 15 },
                    { 16, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8589), 1, 16 },
                    { 17, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8590), 1, 17 },
                    { 18, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8591), 1, 18 },
                    { 19, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8592), 1, 19 },
                    { 20, new DateTime(2026, 3, 3, 3, 57, 46, 413, DateTimeKind.Utc).AddTicks(8593), 1, 20 }
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
                    { 1, new DateTime(2026, 2, 9, 12, 15, 0, 0, DateTimeKind.Unspecified), 21, 11 },
                    { 2, new DateTime(2026, 2, 13, 10, 0, 0, 0, DateTimeKind.Unspecified), 22, 11 },
                    { 3, new DateTime(2026, 2, 19, 14, 30, 0, 0, DateTimeKind.Unspecified), 23, 11 },
                    { 4, new DateTime(2026, 2, 24, 9, 45, 0, 0, DateTimeKind.Unspecified), 24, 11 }
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
