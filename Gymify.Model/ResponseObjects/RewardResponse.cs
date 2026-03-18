using System;

namespace Gymify.Model.ResponseObjects
{
    public class RewardResponse
    {
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty;

        public string? Description { get; set; }

        public int RequiredPoints { get; set; }

        public DateTime ValidFrom { get; set; }

        public DateTime ValidTo { get; set; }

        public string Status { get; set; } = string.Empty;

        public bool IsLockedForEdit { get; set; }

        public bool CanDelete { get; set; }

        public int RedemptionCount { get; set; }
    }
}