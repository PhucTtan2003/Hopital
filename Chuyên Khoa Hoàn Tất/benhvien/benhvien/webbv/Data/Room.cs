using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class Room
{
    public int RoomId { get; set; }

    public string? RoomNumber { get; set; }

    public int? DepartmentId { get; set; }

    public string? RoomType { get; set; }

    public string? Notes { get; set; }

    public virtual Department? Department { get; set; }
}
