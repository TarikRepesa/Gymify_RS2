using Gymify.Services;
using Gymify.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi;
using Gymify.WebAPI.Authentication;
using Gymify.Services.Interfaces;
using Gymify.Services.Services;
using RabbitMQ.Client;
using Gymify.WebAPI.Services;
using DotNetEnv;
using Stripe;
using Gymify.WebAPI.StripeConfig;
using Gymify.Services.Implementations;

Env.Load(Path.Combine(Directory.GetCurrentDirectory(), "..", ".env"));

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<GymifyDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
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
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
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
builder.Services.AddTransient<ISpecialOfferService, SpecialOfferService>();
builder.Services.AddTransient<ITrainingService, TrainingService>();
builder.Services.AddTransient<IWorkerTaskService, WorkerTaskService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IImageService, ImageService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<IRewardService, RewardService>();
builder.Services.AddTransient<IUserRewardService, UserRewardService>();
builder.Services.AddTransient<IReportsService, ReportService>();

var stripeSecret = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");
var stripeWebhookSecret = Environment.GetEnvironmentVariable("STRIPE_WEBHOOK_SECRET");

StripeConfiguration.ApiKey = stripeSecret;

builder.Services.AddSingleton(new StripeSettings
{
    SecretKey = stripeSecret!,
    WebhookSecret = stripeWebhookSecret!
});

builder.Services.AddScoped<StripeService>();

builder.Services.AddSingleton<IConnection>(_ =>
{
    var host = Environment.GetEnvironmentVariable("RABBITMQ_HOST");
    var port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT"));
    var user = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME");
    var pass = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD");
    var vhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST");

    var factory = new ConnectionFactory
    {
        HostName = host,
        Port = port,
        UserName = user,
        Password = pass,
        VirtualHost = vhost
    };

    return factory.CreateConnectionAsync().GetAwaiter().GetResult();
});

builder.Services.AddJwtAuthentication(builder.Configuration);
builder.Services.AddAuthorization();


var app = builder.Build();

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