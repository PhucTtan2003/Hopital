using System;
using System.Collections.Generic;

namespace Booklich.Data;

public partial class Account
{
    public int AccountId { get; set; }

    public string Username { get; set; } = null!;

    public string PasswordAccount { get; set; } = null!;

    public string Roles { get; set; } = null!;

    public virtual ICollection<Patient> Patients { get; set; } = new List<Patient>();
}
