using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class LoyaltyPointController : BaseCRUDController<LoyaltyPointResponse, BaseSearchObject, LoyaltyPointUpsertRequest, LoyaltyPointUpsertRequest>
    {
        ILoyaltyPointService _service;
        public LoyaltyPointController(ILoyaltyPointService service) : base(service)
        {
            _service = service;
        }

        [HttpPost("add")]
    public async Task<IActionResult> Add([FromBody] LoyaltyPointAdjustRequest req)
    {
        var res = await _service.AddPointsAsync(req);
        return Ok(res);
    }

    [HttpPost("subtract")]
    public async Task<IActionResult> Subtract([FromBody] LoyaltyPointAdjustRequest req)
    {
        var res = await _service.SubtractPointsAsync(req);
        return Ok(res);
    }

    }
}
