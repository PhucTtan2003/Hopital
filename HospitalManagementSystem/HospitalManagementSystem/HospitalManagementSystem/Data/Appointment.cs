using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Data;

public partial class Appointment
{
    public int AppointmentId { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public int TimeSlotId { get; set; }

    public decimal Fee { get; set; }

    public string? Notes { get; set; }

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;

    public virtual TimeSlot TimeSlot { get; set; } = null!;
}
