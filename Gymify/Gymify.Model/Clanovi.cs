using System;
using System.Collections.Generic;
using System.Text;

namespace Gymify.Model
{
    public class Clanovi 
    {
        public int ClanId { get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public DateTime DatumRodjenja { get; set; }
    }
}
