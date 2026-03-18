using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class MembershipUpsertRequest
    {
        [Required]
        public string Name { get; set; }

        [Required]
        public int MonthlyPrice { get; set; }

        [Required]
        public int YearPrice { get; set; }
    }
}
