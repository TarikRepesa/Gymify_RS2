using System;

namespace Gymify.Model.ResponseObjects
{
    public class LoyaltyPointResponse
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        public int TotalPoints { get; set; }
    }
}
