using System;

namespace Gymify.Model.ResponseObjects
{
    public class MembershipResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int DurationInDays { get; set; }
        public string Detaisl { get; set; }
    }
}
