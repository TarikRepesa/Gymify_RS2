using Gymify.Model.RequestObjects;
using Gymify.Services.Database;
using Konscious.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace Gymify.Services.Helpers
{
    public static class UserHelper
    {
        public static void CreatePasswordHash(string password, out string hashBase64, out string saltBase64)
        {
            var salt = RandomNumberGenerator.GetBytes(16);
            var hash = HashPasswordWithArgon2id(password, salt);

            hashBase64 = Convert.ToBase64String(hash);
            saltBase64 = Convert.ToBase64String(salt);
        }

        private static byte[] HashPasswordWithArgon2id(string password, byte[] salt)
        {
            var passwordBytes = Encoding.UTF8.GetBytes(password);

            var argon2 = new Argon2id(passwordBytes)
            {
                Salt = salt,

                
                DegreeOfParallelism = 1,
                Iterations = 2,
                MemorySize = 19456 
            };

            return argon2.GetBytes(32);
        }

       public static bool VerifyPassword(string password, string storedHashBase64, string storedSaltBase64)
    {
        if (string.IsNullOrWhiteSpace(password) ||
            string.IsNullOrWhiteSpace(storedHashBase64) ||
            string.IsNullOrWhiteSpace(storedSaltBase64))
            return false;

        var salt = Convert.FromBase64String(storedSaltBase64);
        var storedHash = Convert.FromBase64String(storedHashBase64);

        var computedHash = HashPasswordWithArgon2id(password, salt);

        return CryptographicOperations.FixedTimeEquals(computedHash, storedHash);
    }

        public static string CreateJwt(User user, IConfiguration configuration)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET")!;
            var jwtIssuer = Environment.GetEnvironmentVariable("JWT_ISSUER")!;
        
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username)
            };
        
            foreach (var userRole in user.UserRoles)
            {
                if (!string.IsNullOrEmpty(userRole.Role?.Name))
                    claims.Add(new Claim(ClaimTypes.Role, userRole.Role.Name));
            }
        
            var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var creds = new SigningCredentials(signingKey, SecurityAlgorithms.HmacSha256);
        
            var token = new JwtSecurityToken(
                issuer: jwtIssuer,
                audience: jwtIssuer,
                claims: claims,
                expires: DateTime.UtcNow.AddHours(2),
                signingCredentials: creds
            );
        
            return new JwtSecurityTokenHandler().WriteToken(token);
        }



        public static async Task AssignRoleByFlagsAsync(User entity, UserInsertRequest request, GymifyDbContext _context)
        {
            int? roleId = null;

            if (request.IsAdmin == true) roleId = await GetRoleIdAsync("Admin", _context);
            else if (request.IsTrener == true) roleId = await GetRoleIdAsync("Trener", _context);
            else if (request.IsRadnik == true) roleId = await GetRoleIdAsync("Radnik", _context);
            else if (request.IsUser == true) roleId = await GetRoleIdAsync("Korisnik", _context);

            if (roleId == null)
                throw new InvalidOperationException("Nijedna validna rola nije označena.");

            entity.UserRoles.Add(new UserRole
            {
                UserId = entity.Id,
                RoleId = roleId.Value
            });
        }

        private static async Task<int?> GetRoleIdAsync(string roleName, GymifyDbContext context)
        {
            var role = await context.Roles.FirstOrDefaultAsync(r => r.Name == roleName);
            return role?.Id;
        }


    }
}
