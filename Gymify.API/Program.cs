using DotNetEnv;
using Gymify.EmailConsumer.Configuration;
using Gymify.Services;
using Gymify.Services.Database;
using Gymify.Services.Exceptions;
using Gymify.Services.Implementations;
using Gymify.Services.Interfaces;
using Gymify.Services.Services;
using Gymify.WebAPI.Authentication;
using Gymify.WebAPI.Services;
using Gymify.WebAPI.StripeConfig;
using Mapster;
using MapsterMapper;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using RabbitMQ.Client;
using Stripe;

Env.Load(Path.Combine(Directory.GetCurrentDirectory(), "..", ".env"));

var builder = WebApplication.CreateBuilder(args);

var connectionString = Environment.GetEnvironmentVariable("CONNECTION_STRING");
var jwtSecret = Environment.GetEnvironmentVariable("JWT_SECRET");
var jwtIssuer = Environment.GetEnvironmentVariable("JWT_ISSUER");
var jwtAudience = Environment.GetEnvironmentVariable("JWT_AUDIENCE");

var stripeSecret = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");
var stripeWebhookSecret = Environment.GetEnvironmentVariable("STRIPE_WEBHOOK_SECRET");

var rabbitHost = Environment.GetEnvironmentVariable("RABBITMQ_HOST");
var rabbitPortString = Environment.GetEnvironmentVariable("RABBITMQ_PORT");
var rabbitUser = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME");
var rabbitPass = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD");
var rabbitVHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST");


if (string.IsNullOrWhiteSpace(connectionString))
    throw new InvalidOperationException("CONNECTION_STRING nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(jwtSecret))
    throw new InvalidOperationException("JWT_SECRET nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(jwtIssuer))
    throw new InvalidOperationException("JWT_ISSUER nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(jwtAudience))
    throw new InvalidOperationException("JWT_AUDIENCE nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(stripeSecret))
    throw new InvalidOperationException("STRIPE_SECRET_KEY nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(stripeWebhookSecret))
    throw new InvalidOperationException("STRIPE_WEBHOOK_SECRET nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(rabbitHost))
    throw new InvalidOperationException("RABBITMQ_HOST nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(rabbitPortString) || !int.TryParse(rabbitPortString, out var rabbitPort))
    throw new InvalidOperationException("RABBITMQ_PORT nije validan u .env fajlu.");

if (string.IsNullOrWhiteSpace(rabbitUser))
    throw new InvalidOperationException("RABBITMQ_USERNAME nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(rabbitPass))
    throw new InvalidOperationException("RABBITMQ_PASSWORD nije postavljen u .env fajlu.");

if (string.IsNullOrWhiteSpace(rabbitVHost))
    rabbitVHost = "/";

builder.Services.AddDbContext<GymifyDbContext>(options =>
    options.UseSqlServer(
        connectionString,
        b => b.MigrationsAssembly("Gymify.Services")
    ));


builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Gymify API", Version = "v1" });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Unesi: Bearer {token}"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

TypeAdapterConfig.GlobalSettings.Default
    .IgnoreNullValues(true)
    .PreserveReference(true)
    .ShallowCopyForSameType(true);

builder.Services.AddSingleton(TypeAdapterConfig.GlobalSettings);
builder.Services.AddTransient<IMapper, ServiceMapper>();

builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<ILoyaltyPointHistoryService, LoyaltyPointHistoryService>();
builder.Services.AddTransient<ILoyaltyPointService, LoyaltyPointService>();
builder.Services.AddTransient<IMemberService, MemberService>();
builder.Services.AddTransient<IMembershipService, MembershipService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IReservationService, ReservationService>();
builder.Services.AddTransient<IReviewService, Gymify.Services.Services.ReviewService>();
builder.Services.AddTransient<ITrainingService, TrainingService>();
builder.Services.AddTransient<IWorkerTaskService, WorkerTaskService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IImageService, ImageService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<IRewardService, RewardService>();
builder.Services.AddTransient<IUserRewardService, UserRewardService>();
builder.Services.AddTransient<IReportsService, ReportService>();

builder.Services.Configure<AppConfig>(
    builder.Configuration.GetSection("AppConfig")
);

StripeConfiguration.ApiKey = stripeSecret;

builder.Services.AddSingleton(new StripeSettings
{
    SecretKey = stripeSecret,
    WebhookSecret = stripeWebhookSecret
});

builder.Services.AddScoped<IStripeService,StripeService>();


builder.Services.AddSingleton<IConnection>(_ =>
{
    var factory = new ConnectionFactory
    {
        HostName = rabbitHost,
        Port = rabbitPort,
        UserName = rabbitUser,
        Password = rabbitPass,
        VirtualHost = rabbitVHost
    };

    return factory.CreateConnectionAsync().GetAwaiter().GetResult();
});

builder.Services.AddJwtAuthentication();
builder.Services.AddAuthorization();

var app = builder.Build();

app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        context.Response.ContentType = "application/json";

        var error = context.Features.Get<IExceptionHandlerFeature>()?.Error;

        switch (error)
        {
            case UserException ex:
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsJsonAsync(new { message = ex.Message });
                break;

            case ForbiddenException ex:
                context.Response.StatusCode = StatusCodes.Status403Forbidden;
                await context.Response.WriteAsJsonAsync(new { message = ex.Message });
                break;

            case NotFoundException ex:
                context.Response.StatusCode = StatusCodes.Status404NotFound;
                await context.Response.WriteAsJsonAsync(new { message = ex.Message });
                break;

            default:
                context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                await context.Response.WriteAsJsonAsync(new
                {
                    message = "Došlo je do neočekivane greške."
                });
                break;
        }
    });
});


if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<GymifyDbContext>();
    db.Database.Migrate();
}

app.UseStaticFiles();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.Run();