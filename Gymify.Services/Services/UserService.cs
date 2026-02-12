using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Gymify.Model.ResponseObject;

namespace Gymify.Services.Services
{
    public class UserService : BaseCRUDService<UserResponse, BaseSearchObject, User, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        public UserService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

    //     protected override IQueryable<User> ApplyFilter(IQueryable<User> query, BaseSearchObject search)
    //     {
    //         return base.ApplyFilter(query, search);
    //     }

    //     protected override User MapInsertToEntity(User entity, UserInsertRequest request)
    //     {
    //         _mapper.Map(request, entity);

    //         if (!string.IsNullOrWhiteSpace(request.Password))
    //         {
    //             UserHelper.CreatePasswordHash(request.Password, out var hash, out var salt);
    //             entity.PasswordHash = hash;
    //             entity.PasswordSalt = salt;
    //         }

    //         entity.CreatedAt = DateTime.UtcNow;
    //         return entity;
    //     }

    //     protected override void MapUpdateToEntity(User entity, UserUpdateRequest request)
    //     {
    //         var createdAt = entity.CreatedAt;

    //         _mapper.Map(request, entity);

    //         entity.CreatedAt = createdAt;

    //         if (!string.IsNullOrWhiteSpace(request.Password))
    //         {
    //             UserHelper.CreatePasswordHash(request.Password, out var hash, out var salt);
    //             entity.PasswordHash = hash;
    //             entity.PasswordSalt = salt;
    //         }
    //     }

    //     protected override async Task BeforeInsert(User entity, UserInsertRequest request)
    //     {
    //         var exists = await _context.Users.AnyAsync(x =>
    //             x.Username == entity.Username || x.Email == entity.Email);

    //         if (exists)
    //             throw new InvalidOperationException("Korisnik sa istim username/email već postoji.");

    //         await UserHelper.AssignRoleByIsVlasnikAsync(entity, request);
    //     }

    //     protected override async Task BeforeUpdate(User entity, UserUpdateRequest request)
    //     {
    //         var exists = await _context.Users.AnyAsync(x =>
    //             x.Id != entity.Id && (x.Username == request.Username || x.Email == request.Email));

    //         if (exists)
    //             throw new InvalidOperationException("Korisnik sa istim username/email već postoji.");
    //     }

    //     public async Task<LoginResponse> LoginAsync(LoginRequest request)
    //     {
    //         var user = await _context.Users
    //             .Include(u => u.UserRoles)
    //                 .ThenInclude(ur => ur.Role)
    //             .FirstOrDefaultAsync(x => x.Username == request.Username);

    //         if (user == null || !user.IsActive)
    //             throw new UnauthorizedAccessException("Pogrešan username ili password.");

    //         if (!UserHelper.VerifyPassword(request.Password, user.PasswordHash, user.PasswordSalt))
    //             throw new UnauthorizedAccessException("Pogrešan username ili password.");

    //         var token = UserHelper.CreateJwt(user, _configuration);

    //         var response = new LoginResponse
    //         {
    //             UserId = user.Id,
    //             UserName = request.Username,
    //             Token = token,
    //             Roles = user.UserRoles
    //                 .Select(ur => ur.Role.Name)
    //                 .ToList()
    //         };

    //         user.LastLoginAt = DateTime.UtcNow;
    //         await _context.SaveChangesAsync();

    //         return response;
    //     }
    }
}
