using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class Staff
{
    public int StaffId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? Position { get; set; }

    public int? DepartmentId { get; set; }

    public string Phone { get; set; } = null!;

    public string? Email { get; set; }

    public virtual Department? Department { get; set; }
}
