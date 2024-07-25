namespace Quản_Lý_bệnh_viện.Models
{
    public class Equipment
    {
        public int EquipmentID { get; set; }
        public string EquipmentName { get; set; }
        public int DepartmentID { get; set; }
        public string Status { get; set; }
        public DateTime LastMaintenanceDate { get; set; }

        // Navigation properties
        public Department Department { get; set; }
    }
}
