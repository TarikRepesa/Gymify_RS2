using System;

namespace Gymify.Model.RequestObjects
{
    public class MembershipUpsertRequest
    {
        public string Name { get; set; }
        public int DurationInDays { get; set; }
        public string Detaisl { get; set; }
    }
}
