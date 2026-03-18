using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

//Get: Korisnik,Admin,Radnik
//Delete, Create: Admin,Radnik 

namespace Gymify.API.Controllers
{
    
    public class NotificationController : BaseCRUDController<NotificationResponse, NotificationSearchObject, NotificationUpsertRequest, NotificationUpsertRequest>
    {
        public NotificationController(INotificationService service) : base(service)
        {
        }

        [Authorize(Roles = "Korisnik,Admin,Radnik,Trener")]
        public override Task<PagedResult<NotificationResponse>> Get([FromQuery] NotificationSearchObject? search = null)
        {
            return base.Get(search);
        }

        [Authorize(Roles = "Admin,Radnik,Trener")]
        public override Task<NotificationResponse?> GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin,Radnik,Trener")]
        public override Task<NotificationResponse?> Update(int id, [FromBody] NotificationUpsertRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin,Radnik,Trener")]
        public override Task<NotificationResponse> Create([FromBody] NotificationUpsertRequest request)
        {
            return base.Create(request);
        }

        [Authorize(Roles = "Admin,Radnik")]
        public override Task<bool> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
