using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class TrainingController : BaseCRUDController<TrainingResponse, TrainingSearchObject, TrainingUpsertRequest, TrainingUpsertRequest>
    {
        ITrainingService _trainingService;
        public TrainingController(ITrainingService service) : base(service)
        {
            _trainingService = service;
        }

        [HttpPost("{id}/up")]
        public async Task<IActionResult> Up(int id)
        {
            await _trainingService.Up(id);
            return Ok(true);
        }

        [HttpPost("{id}/down")]
        public async Task<IActionResult> Down(int id)
        {
            await _trainingService.Down(id);
            return Ok(true);
        }

        [HttpGet("recommended")]
        [Authorize(Roles = "Korisnik")]
        public async Task<List<TrainingResponse>> GetRecommended([FromQuery] int userId, [FromQuery] int take = 3)
        {
            return await _trainingService.GetRecommended(userId, take);
        }
    }
}
