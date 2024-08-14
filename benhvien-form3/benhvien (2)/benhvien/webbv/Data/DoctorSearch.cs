using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class DoctorSearch
{
    public int DoctorSearchId { get; set; }

    public string Specialty { get; set; } = null!;

    public int DoctorId { get; set; }

    public virtual Doctor Doctor { get; set; } = null!;
}
