using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObject;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class UserController : BaseCRUDController<UserResponse, BaseSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;
        public UserController(IUserService service) : base(service)
        {
            _userService = service;
        }

        // [AllowAnonymous]
        // [HttpPost("login")]
        // public async Task<LoginResponse> Login([FromBody] LoginRequest request)
        // {
        //     return await _userService.LoginAsync(request);
        // }
    }
}
