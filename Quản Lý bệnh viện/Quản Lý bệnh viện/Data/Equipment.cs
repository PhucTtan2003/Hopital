﻿using System;
using System.Collections.Generic;

namespace Quản_Lý_bệnh_viện.Data;

public partial class Equipment
{
    public int EquipmentId { get; set; }

    public string? EquipmentName { get; set; }

    public int? DepartmentId { get; set; }

    public string? Notes { get; set; }

    public DateOnly? LastMaintenanceDate { get; set; }

    public virtual Department? Department { get; set; }
}
