using System;
using System.Collections.Generic;

namespace Booklich.Data;

public partial class Medication
{
    public int MedicationId { get; set; }

    public string MedicationName { get; set; } = null!;

    public string? DescriptionMedications { get; set; }

    public string Dosage { get; set; } = null!;

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();
}
