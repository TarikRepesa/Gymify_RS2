using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace Gymify.Services.Services
{
    public class LoyaltyPointService : BaseCRUDService<LoyaltyPointResponse, BaseSearchObject, LoyaltyPoint, LoyaltyPointUpsertRequest, LoyaltyPointUpsertRequest>, ILoyaltyPointService
    {
        private readonly GymifyDbContext _context;
        private readonly IMapper _mapper;
        public LoyaltyPointService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<LoyaltyPointResponse> AddPointsAsync(LoyaltyPointAdjustRequest req)
    {
        var lp = await _context.LoyaltyPoints
            .FirstOrDefaultAsync(x => x.UserId == req.UserId);

        if (lp == null)
        {
            lp = new LoyaltyPoint
            {
                UserId = req.UserId,
                TotalPoints = 0
            };
            _context.LoyaltyPoints.Add(lp);
        }

        lp.TotalPoints += req.Points;

        await _context.SaveChangesAsync();

        return _mapper.Map<LoyaltyPointResponse>(lp);
    }

    public async Task<LoyaltyPointResponse> SubtractPointsAsync(LoyaltyPointAdjustRequest req)
    {
        var lp = await _context.LoyaltyPoints
            .FirstOrDefaultAsync(x => x.UserId == req.UserId);

        if (lp == null)
            throw new Exception("LoyaltyPoint nije pronađen za korisnika.");

        lp.TotalPoints -= req.Points;

        await _context.SaveChangesAsync();

        return _mapper.Map<LoyaltyPointResponse>(lp);
    }
    }
}
