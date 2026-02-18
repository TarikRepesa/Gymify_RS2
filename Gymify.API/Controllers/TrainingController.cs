using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using Gymify.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Gymify.API.Controllers
{
    public class TrainingController : BaseCRUDController<TrainingResponse, TrainingSearchObject, TrainingUpsertRequest, TrainingUpsertRequest>
    {
        public TrainingController(ITrainingService service) : base(service)
        {
        }
    }
}
