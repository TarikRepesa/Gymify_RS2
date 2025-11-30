using Gymify.Model;
using Gymify.Services;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ClanoviController : ControllerBase
    {
        protected IClanoviService _service;

        public ClanoviController(IClanoviService service)
        {
            _service = service;
        }

        [HttpGet]
        public List<Clanovi> GetList()
        {
            return _service.GetList();
        }
    }
}
