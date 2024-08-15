using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class Session
{
    public int SessionId { get; set; }

    public int? PatientId { get; set; }

    public string? SessionToken { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Patient? Patient { get; set; }
}
