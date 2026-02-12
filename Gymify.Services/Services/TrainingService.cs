using Gymify.Services.Database;
using Gymify.Services.Interfaces;
using Gymify.Model.RequestObjects;
using Gymify.Model.ResponseObjects;
using Gymify.Model.SearchObjects;
using MapsterMapper;

namespace Gymify.Services.Services
{
    public class TrainingService : BaseCRUDService<TrainingResponse, BaseSearchObject, Training, TrainingUpsertRequest, TrainingUpsertRequest>, ITrainingService
    {
        public TrainingService(GymifyDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
