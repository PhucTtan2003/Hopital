using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Data;

public partial class Medication
{
    public int MedicationId { get; set; }

    public string MedicationName { get; set; } = null!;

    public string MedicationImage { get; set; } = null!;

    public string FeeMedication { get; set; } = null!;

    public string StatusMedication { get; set; } = null!;

    public string? DescriptionMedications { get; set; }

    public string Dosage { get; set; } = null!;

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
}
