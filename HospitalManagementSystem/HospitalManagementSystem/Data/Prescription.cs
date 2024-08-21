using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Data;

public partial class Prescription
{
    public int PrescriptionId { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public int MedicationId { get; set; }

    public DateOnly DateBill { get; set; }

    public string Dosage { get; set; } = null!;

    public string? Instructions { get; set; }

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Medication Medication { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;
}
