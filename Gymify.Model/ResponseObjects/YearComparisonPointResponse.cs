namespace Gymify.Model.ResponseObjects
{
    public class YearComparisonPointResponse
    {
        public int Month { get; set; }
        public string Label { get; set; } = string.Empty;
        public decimal Income2025 { get; set; }
        public decimal Income2026 { get; set; }
        public int Payments2025 { get; set; }
        public int Payments2026 { get; set; }
    }
}