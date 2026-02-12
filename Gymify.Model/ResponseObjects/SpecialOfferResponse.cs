using System;

namespace Gymify.Model.ResponseObjects
{
    public class SpecialOfferResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Details { get; set; }
        public int ValueOfLoyaltyPoints { get; set; }
    }
}
