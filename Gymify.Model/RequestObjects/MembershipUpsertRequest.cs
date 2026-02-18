using System.ComponentModel.DataAnnotations;

namespace Gymify.Model.RequestObjects
{
    public class MembershipUpsertRequest
    {
        [Required]
        public string Name { get; set; }

        [Range(0.01, double.MaxValue)]
        public double MonthlyPrice { get; set; }

        [Range(0.01, double.MaxValue)]
        public double YearPrice { get; set; }
    }
}
