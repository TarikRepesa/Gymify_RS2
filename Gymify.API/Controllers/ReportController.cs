using Gymify.Model.ResponseObjects;
using Gymify.Model.ResponseObjects.Reports;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin,Trener,Radnik")]
    public class ReportsController : ControllerBase
    {
        private readonly IReportsService _service;

        public ReportsController(IReportsService service)
        {
            _service = service;
        }

        [HttpGet("top-trainers")]
        public async Task<ActionResult<List<TopTrainerReportItem>>> TopTrainers(
            [FromQuery] int year,
            [FromQuery] int take = 5)
        {
            if (year < 2000 || year > 2100) return BadRequest("Neispravna godina.");
            if (take < 1) take = 1;
            if (take > 30) take = 30;

            var data = await _service.GetTopTrainersAsync(year, take);
            return Ok(data);
        }

        [HttpGet("best-training-alltime")]
        public async Task<ActionResult<TopTrainingAllTimeReportItem?>> GetBestTrainingAllTime()
        {
            var result = await _service.GetBestTrainingAllTimeAsync();
            return Ok(result);
        }

        [HttpGet("dashboard")]
        public async Task<ActionResult<DashboardReportResponse>> Dashboard(
            [FromQuery] int year,
            [FromQuery] int takeTopTrainers = 5)
        {
            if (year < 2000 || year > 2100) return BadRequest("Neispravna godina.");
            if (takeTopTrainers < 1) takeTopTrainers = 1;
            if (takeTopTrainers > 30) takeTopTrainers = 30;

            var data = await _service.GetDashboardAsync(year, takeTopTrainers);
            return Ok(data);
        }

        [HttpGet("membership-revenue-summary")]
        public ActionResult<MembershipRevenueSummaryResponse> GetMembershipRevenueSummary([FromQuery] int year)
        {
            return Ok(_service.GetMembershipRevenueSummary(year));
        }

        [HttpGet("income-by-month")]
        public ActionResult<List<IncomeByMonthResponse>> GetIncomeByMonth([FromQuery] int year)
        {
            return Ok(_service.GetIncomeByMonth(year));
        }
    }
}