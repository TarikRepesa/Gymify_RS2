using System;

namespace Gymify.Model.ResponseObjects
{
    public class MembershipResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public double MonthlyPrice { get; set; }

        public double YearPrice { get; set; }

        public DateTime CreatedAt { get; set; }
    }
}
