using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Data;

public partial class Room
{
    public int RoomId { get; set; }

    public string RoomNumber { get; set; } = null!;

    public int DepartmentId { get; set; }

    public string RoomType { get; set; } = null!;

    public string? Notes { get; set; }

    public virtual Department Department { get; set; } = null!;
}
