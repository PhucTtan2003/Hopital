namespace Quản_Lý_bệnh_viện.Models
{
    public class Department
    {
        public int DepartmentID { get; set; }
        public string DepartmentName { get; set; }
        public string Location { get; set; }
        public ICollection<Doctor> Doctors { get; set; }
        public ICollection<Staff> Staff { get; set; }
        public ICollection<Equipment> Equipment { get; set; }
    }
}
