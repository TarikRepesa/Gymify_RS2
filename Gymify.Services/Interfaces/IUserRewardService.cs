using System.Threading.Tasks;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IUserRewardService 
        : ICRUDService<
            UserRewardResponse,
            UserRewardSearchObject,
            UserRewardInsertRequest,
            UserRewardUpdateRequest>
    {
        // Custom metoda za redeem nagrade
        Task<UserRewardResponse?> RedeemAsync(int userId, int rewardId);
    }
}