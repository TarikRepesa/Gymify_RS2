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

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<GymifyDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        b => b.MigrationsAssembly("Gymify.API")
    ));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Rentify API", Version = "v1" });

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
builder.Services.AddTransient<IReviewService, ReviewService>();
builder.Services.AddTransient<ISpecialOfferService, SpecialOfferService>();
builder.Services.AddTransient<ITrainingService, TrainingService>();
builder.Services.AddTransient<IWorkerTaskService, WorkerTaskService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IImageService, ImageService>();
builder.Services.AddTransient<INotificationService, NotificationService>();


builder.Services.AddJwtAuthentication(builder.Configuration);
builder.Services.AddAuthorization();


var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.Run();