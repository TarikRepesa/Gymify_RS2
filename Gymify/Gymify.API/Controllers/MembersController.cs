using Gymify.Model;
using Gymify.Services;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MembersController : ControllerBase
    {
        protected IMembersService _service;

        public MembersController(IMembersService service)
        {
            _service = service;
        }

        [HttpGet]
        public List<Members> GetList()
        {
            return _service.GetList();
        }

        [HttpGet("{id}")] 
        public ActionResult<Members> GetById(int id) 
        {
            try
            {
                var clan = _service.GetById(id);
                return Ok(clan);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPost]
        public ActionResult<Members> Insert(Members clan)
        {
            try
            {
                var noviClan = _service.Insert(clan);
                return Ok(noviClan);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut]
        public ActionResult<Members> Update(Members clan)
        {
            try
            {
                var updatedClan = _service.Update(clan);
                return Ok(updatedClan);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpDelete]
        public ActionResult<Members> Delete(Members clan)
        {
            try
            {
                var deleteClan = _service.Delete(clan);
                
                if (deleteClan)
                    return Ok(deleteClan);
                else
                    return NotFound($"Clan sa id {clan.MemberId} ne postoji");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
