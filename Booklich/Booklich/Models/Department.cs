using Booklich.Data;

namespace Booklich.Models
{
    public class Department
    {
        public int DepartmentID { get; set; }
        public string DepartmentName { get; set; }
        public string LocationHospital { get; set; }

        public ICollection<Doctor> Doctors { get; set; }
    }
}
