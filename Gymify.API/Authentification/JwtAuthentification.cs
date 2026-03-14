using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Text;

namespace Gymify.WebAPI.Authentication
{
    public static class JwtAuthentication
    {
        public static IServiceCollection AddJwtAuthentication(this IServiceCollection services)
        {
            var jwtKey = Environment.GetEnvironmentVariable("JWT_SECRET");
            var jwtIssuer = Environment.GetEnvironmentVariable("JWT_ISSUER");
            var jwtAudience = Environment.GetEnvironmentVariable("JWT_AUDIENCE");

            if (string.IsNullOrWhiteSpace(jwtKey))
                throw new InvalidOperationException("JWT_SECRET nije konfigurisan u .env fajlu.");

            if (string.IsNullOrWhiteSpace(jwtIssuer))
                throw new InvalidOperationException("JWT_ISSUER nije konfigurisan u .env fajlu.");

            if (string.IsNullOrWhiteSpace(jwtAudience))
                throw new InvalidOperationException("JWT_AUDIENCE nije konfigurisan u .env fajlu.");

            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = true,
                    ValidateIssuerSigningKey = true,

                    ValidIssuer = jwtIssuer,
                    ValidAudience = jwtAudience,

                    IssuerSigningKey = new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(jwtKey)
                    )
                };
            });

            services.AddAuthorization();

            return services;
        }
    }
}