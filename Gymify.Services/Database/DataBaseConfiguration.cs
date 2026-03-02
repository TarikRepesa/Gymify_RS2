using Gymify.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Gymify.Services.Database
{
    public class GymifyDbContextFactory : IDesignTimeDbContextFactory<GymifyDbContext>
    {
        public GymifyDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<GymifyDbContext>();

            optionsBuilder.UseSqlServer(
                "Server=.\\SQLEXPRESS;Database=GymifyDb;Trusted_Connection=True;TrustServerCertificate=True;"
            );

            return new GymifyDbContext(optionsBuilder.Options);
        }
    }
}