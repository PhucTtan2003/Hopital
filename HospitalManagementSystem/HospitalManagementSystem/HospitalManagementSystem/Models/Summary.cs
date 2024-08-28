using HospitalManagementSystem.Data;
using Microsoft.CodeAnalysis;

namespace HospitalManagementSystem.Models
{
    public class Summary
    {
        public Patient Patient { get; set; }
        public Doctor Doctor { get; set; }
        public SelectSpecialty Specialty { get; set; }
        public TimeSlot TimeSlot { get; set; }
        public int Fee { get; set; }
        public string? Notes { get; set; }
    }
}
