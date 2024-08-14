using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class Patient
{
    public int PatientId { get; set; }

    public int? AccountId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public DateOnly? DateOfBirth { get; set; }

    public string? Gender { get; set; }

    public string? AddressPatients { get; set; }

    public string Phone { get; set; } = null!;

    public string? Email { get; set; }

    public virtual Account? Account { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual ICollection<Billing> Billings { get; set; } = new List<Billing>();

    public virtual ICollection<MedicalRecord> MedicalRecords { get; set; } = new List<MedicalRecord>();

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();

    public virtual ICollection<SelectSpecialty> SelectSpecialties { get; set; } = new List<SelectSpecialty>();

    public virtual ICollection<Session> Sessions { get; set; } = new List<Session>();
}
