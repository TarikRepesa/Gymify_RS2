using Gymify.Services;
using Gymify.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<GymifyDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        b => b.MigrationsAssembly("Gymify.API")
    ));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


TypeAdapterConfig.GlobalSettings.Default
            .IgnoreNullValues(true)      
            .PreserveReference(true)     
            .ShallowCopyForSameType(true);

builder.Services.AddSingleton(TypeAdapterConfig.GlobalSettings);
builder.Services.AddTransient<IMapper, ServiceMapper>();
//builder.Services.AddTransient<IMembersService, MembersService>();


var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();