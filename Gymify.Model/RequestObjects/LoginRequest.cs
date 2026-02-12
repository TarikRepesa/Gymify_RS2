// Rentify.Model/Requests/LoginRequest.cs
using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class LoginRequest
    {
        [Required]
        public string Username { get; set; } = string.Empty;

        [Required]
        public string Password { get; set; } = string.Empty;
    }
}
