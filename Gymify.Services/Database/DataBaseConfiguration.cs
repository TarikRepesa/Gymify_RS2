using DotNetEnv;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Gymify.Services.Database
{
    public class GymifyDbContextFactory : IDesignTimeDbContextFactory<GymifyDbContext>
    {
        public GymifyDbContext CreateDbContext(string[] args)
        {
            Env.Load(Path.Combine(Directory.GetCurrentDirectory(), "..", ".env"));

            var connectionString = Environment.GetEnvironmentVariable("CONNECTION_STRING");

            if (string.IsNullOrWhiteSpace(connectionString))
                throw new InvalidOperationException("CONNECTION_STRING nije postavljen u .env fajlu.");

            var optionsBuilder = new DbContextOptionsBuilder<GymifyDbContext>();
            optionsBuilder.UseSqlServer(
                connectionString,
                b => b.MigrationsAssembly("Gymify.Services")
            );

            return new GymifyDbContext(optionsBuilder.Options);
        }
    }
}