using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Data;

public partial class TimeSlot
{
    public int TimeSlotId { get; set; }

    public int DoctorId { get; set; }

    public DateTime Date { get; set; }

    public string Time { get; set; } = null!;

    public bool IsAvailable { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual Doctor Doctor { get; set; } = null!;
}
