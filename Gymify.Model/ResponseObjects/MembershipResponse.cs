using System;

namespace Gymify.Model.ResponseObjects
{
    public class MembershipResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public int MonthlyPrice { get; set; }

        public int YearPrice { get; set; }

        public DateTime CreatedAt { get; set; }
    }
}
