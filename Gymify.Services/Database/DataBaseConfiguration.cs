using Gymify.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace eTravelAgencija.Services.Database
{
    public class RentifyDbContextFactory : IDesignTimeDbContextFactory<GymifyDbContext>
    {
        public GymifyDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<GymifyDbContext>();

            optionsBuilder.UseSqlServer(
                "Server=localhost;Database=GymifyDb;Trusted_Connection=True;TrustServerCertificate=True;"
            );

            return new GymifyDbContext(optionsBuilder.Options);
        }
    }
}
