﻿using System;
using System.Collections.Generic;

namespace Booklich.Data;

public partial class Doctor
{
    public int DoctorId { get; set; }

    public string FullName { get; set; } = null!;

    public string Position { get; set; } = null!;

    public string Specialty { get; set; } = null!;

    public string? ImageUrl { get; set; }

    public string DescriptionDoctor { get; set; } = null!;

    public string Experience { get; set; } = null!;

    public string Education { get; set; } = null!;

    public int? DepartmentId { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual Department? Department { get; set; }

    public virtual ICollection<MedicalRecord> MedicalRecords { get; set; } = new List<MedicalRecord>();

    public virtual ICollection<Prescription> Prescriptions { get; set; } = new List<Prescription>();

    public virtual ICollection<TimeSlot> TimeSlots { get; set; } = new List<TimeSlot>();
}
