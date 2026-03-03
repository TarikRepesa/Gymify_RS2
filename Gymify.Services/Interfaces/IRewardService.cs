using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;

namespace Gymify.Services.Interfaces
{
    public interface IRewardService 
        : ICRUDService<
            RewardResponse,
            RewardSearchObject,
            RewardInsertRequest,
            RewardUpdateRequest>
    {
        // Ovdje kasnije možeš dodati custom metode ako zatreba
        // npr:
        // Task<bool> ActivateRewardAsync(int id);
    }
}