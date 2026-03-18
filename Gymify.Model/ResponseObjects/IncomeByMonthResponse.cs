namespace Gymify.Model.ResponseObjects
{
    public class IncomeByMonthResponse
    {
        public int Month { get; set; }
        public string Label { get; set; } = string.Empty;
        public double TotalIncome { get; set; }
        public int PaymentCount { get; set; }
    }
}