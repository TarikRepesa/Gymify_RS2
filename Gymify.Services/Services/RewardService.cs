using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Services.Services;
using MapsterMapper;

public class RewardService
    : BaseCRUDService<
        RewardResponse,
        RewardSearchObject,
        Reward,
        RewardInsertRequest,
        RewardUpdateRequest>,
      IRewardService
{
    public RewardService(GymifyDbContext context, IMapper mapper)
        : base(context, mapper) { }

    protected override IQueryable<Reward> ApplyFilter(IQueryable<Reward> query, RewardSearchObject search)
    {
        if (!string.IsNullOrWhiteSpace(search.Name))
        {
            var s = search.Name.ToLower();
            query = query.Where(x => x.Name.ToLower().Contains(s));
        }

        if (search.IsActive.HasValue)
            query = query.Where(x => x.IsActive == search.IsActive.Value);

        return query;
    }
}