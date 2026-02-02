using Gymify.Model;

namespace Gymify.Services
{
    public interface IMembersService
    {
        List<Members> GetList();   

        Members GetById (int id);

        Members Insert(Members clan);

        Members Update(Members clan);

        bool Delete(Members clan);
    }
}
