using System;

namespace Gymify.Model.RequestObjects
{
    public class SpecialOfferUpsertRequest
    {
        public string Name { get; set; }
        public string Details { get; set; }
        public int ValueOfLoyaltyPoints { get; set; }
    }
}
