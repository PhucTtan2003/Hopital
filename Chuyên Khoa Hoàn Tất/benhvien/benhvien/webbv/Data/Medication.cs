using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class Medication
{
    public int MedicationId { get; set; }

    public string? MedicationName { get; set; }

    public string? DescriptionMedications { get; set; }

    public string? Dosage { get; set; }

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
}
