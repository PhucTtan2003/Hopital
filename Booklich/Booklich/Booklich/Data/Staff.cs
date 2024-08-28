using System;
using System.Collections.Generic;

namespace Booklich.Data;

public partial class Staff
{
    public int StaffId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Position { get; set; } = null!;

    public int DepartmentId { get; set; }

    public string Phone { get; set; } = null!;

    public string? Email { get; set; }

    public virtual Department Department { get; set; } = null!;
}
