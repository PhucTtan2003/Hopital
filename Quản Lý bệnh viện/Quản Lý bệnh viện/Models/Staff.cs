namespace Quản_Lý_bệnh_viện.Models
{
    public class Staff
    {
        public int StaffID { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Position { get; set; }
        public int DepartmentID { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }

        // Navigation properties
        public Department Department { get; set; }
    }
}
