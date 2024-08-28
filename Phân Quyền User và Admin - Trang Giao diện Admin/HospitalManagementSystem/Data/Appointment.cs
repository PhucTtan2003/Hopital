using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Data;

public partial class Appointment
{
    public int AppointmentId { get; set; }

    public int PatientId { get; set; }

    public int DoctorId { get; set; }

    public DateOnly AppointmentDate { get; set; }

    public TimeOnly AppointmentTime { get; set; }

    public string? Notes { get; set; }

    public string? Username { get; set; }  // Thêm thuộc tính Username


    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;
}
