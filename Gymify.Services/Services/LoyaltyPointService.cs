using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Gymify.Services.Exceptions;

namespace Gymify.Services.Services
{
    public class LoyaltyPointService 
        : BaseCRUDService<LoyaltyPointResponse, LoyaltyPointSearchObject, LoyaltyPoint, LoyaltyPointUpsertRequest, LoyaltyPointUpsertRequest>, ILoyaltyPointService
    {
        private readonly GymifyDbContext _context;
        private readonly IMapper _mapper;

        public LoyaltyPointService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        protected override IQueryable<LoyaltyPoint> ApplyFilter(IQueryable<LoyaltyPoint> query, LoyaltyPointSearchObject search)
        {
            query = base.ApplyFilter(query, search);

            if (search == null)
                return query;

            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            return query;
        }

        protected override IQueryable<LoyaltyPoint> AddInclude(IQueryable<LoyaltyPoint> query, LoyaltyPointSearchObject search)
        {
            if (search.IncludeUser.HasValue)
            {
                query = query.Include(l => l.User);
            }
            return base.AddInclude(query, search);  
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
                throw new NotFoundException("LoyaltyPoint nije pronađen za korisnika.");

            lp.TotalPoints -= req.Points;

            await _context.SaveChangesAsync();

            return _mapper.Map<LoyaltyPointResponse>(lp);
        }
    }
}