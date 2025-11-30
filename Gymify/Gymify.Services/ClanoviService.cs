using Gymify.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Gymify.Services
{
    public class ClanoviService : IClanoviService
    {
        public List<Clanovi> List = new List<Clanovi>()
        {
            new Clanovi()
            {
                Ime = "John",
                Prezime = "Smith",
                DatumRodjenja = DateTime.Parse("2000-01-01")
            },
            new Clanovi()
            {
                Ime = "Tarik",
                Prezime = "Repesa",
                DatumRodjenja = DateTime.Parse("1999-07-10")
            }
        };    

        public List<Clanovi> GetList()
        {
            return List;
        }
    }
}
