using System;
using System.Collections.Generic;

namespace webbv.Data;

public partial class Billing
{
    public int BillingId { get; set; }

    public int? PatientId { get; set; }

    public DateOnly? DateBill { get; set; }

    public decimal? Amount { get; set; }

    public string? Notes { get; set; }

    public virtual Patient? Patient { get; set; }
}
