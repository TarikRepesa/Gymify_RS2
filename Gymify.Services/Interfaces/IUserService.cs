using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObject;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IUserService : ICRUDService<UserResponse, BaseSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        // Task<LoginResponse> LoginAsync(LoginRequest request);
    }
}
