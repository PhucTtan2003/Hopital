using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class SelectSpecialty
{
    public int Id { get; set; }

    public int PatientId { get; set; }

    public string Specialty { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;
}
