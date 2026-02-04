using Gymify.Model;
using Gymify.Services.Database;

namespace Gymify.Services
{
    public class MembersService : IMembersService
    {
        private readonly ApplicationDbContext _context;

        public MembersService(ApplicationDbContext context)
        {
            _context = context;
        }


        //private static List<Members> List = new List<Members>() 
        //{
        //    new Members()
        //    {
        //        MemberId = 1,
        //        Name = "John",
        //        Surname = "Smith",
        //        DateOfBirth = DateTime.Parse("2000-01-01")
        //    },
        //    new Members()
        //    {
        //        MemberId = 2,
        //        Name = "Tarik",
        //        Surname = "Repesa",
        //        DateOfBirth = DateTime.Parse("1999-07-10")
        //    },
        //    new Members()
        //    {
        //        MemberId = 3,
        //        Name = "James",
        //        Surname = "Harden",
        //        DateOfBirth = DateTime.Parse("1989-04-12")
        //    },
        //    new Members()
        //    {
        //        MemberId = 4,
        //        Name = "Peter",
        //        Surname = "Griffin",
        //        DateOfBirth = DateTime.Parse("2002-01-01")
        //    },
        //    new Members()
        //    {
        //        MemberId = 5,
        //        Name = "John",
        //        Surname = "Doe",
        //        DateOfBirth = DateTime.Parse("2000-01-01")
        //    }
        //};    

        //private static int _nextId = 6;  

        public List<Members> GetList()
        {
            return _context.Members.ToList();
        }

        public Members GetById(int id)
        {
            var clan = _context.Members.FirstOrDefault(x => x.MemberId == id);
            if (clan == null)
                throw new Exception($"Clan sa id {id} ne postoji");
            
            return clan;
        }

        public Members Insert(Members clan)
        {
            if (string.IsNullOrWhiteSpace(clan.Name))
                throw new Exception("Ime je obavezno!");
            if (string.IsNullOrWhiteSpace(clan.Surname))
                throw new Exception("Prezime je obavezno!");

            _context.Members.Add(clan);
            _context.SaveChanges();

            return clan;
        }

        public Members Update(Members clan)
        {
            var postojiLiClan = _context.Members.FirstOrDefault(x => x.MemberId == clan.MemberId);
            if (postojiLiClan == null)
                throw new Exception($"Clan sa id {clan.MemberId} ne postoji!");

            postojiLiClan.Name = clan.Name;
            postojiLiClan.Surname = clan.Surname;
            postojiLiClan.DateOfBirth = clan.DateOfBirth;
            _context.SaveChanges();

            return postojiLiClan;

        }

        public bool Delete(Members clan)
        {
            var memberToDelete = _context.Members.FirstOrDefault(x => x.MemberId == clan.MemberId);
            if (memberToDelete == null)
                return false;

            _context.Members.Remove(memberToDelete);
            _context.SaveChanges();

            return true;
        }
    }
}
