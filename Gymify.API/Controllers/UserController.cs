using System.Security.Claims;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObject;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class UserController : BaseCRUDController<UserResponse, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;
        public UserController(IUserService service) : base(service)
        {
            _userService = service;
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<LoginResponse> Login([FromBody] LoginRequest request)
        {
            return await _userService.LoginAsync(request);
        }

        [Authorize]
        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword(
        [FromBody] ForgotPasswordRequest request)
        {
            await _userService.ForgotPasswordAsync(request.Email);

            return Ok("Ako email postoji, poslan je link za reset lozinke.");
        }

        [Authorize(Roles = "Admin,Korisnik")]
        [HttpPost]
        public override Task<UserResponse> Create([FromBody] UserInsertRequest request)
        {
            return base.Create(request);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrWhiteSpace(userIdClaim) || !int.TryParse(userIdClaim, out var userId))
                return Unauthorized();

            await _userService.ChangePasswordAsync(userId, request);
            return Ok();
        }
    }
}
