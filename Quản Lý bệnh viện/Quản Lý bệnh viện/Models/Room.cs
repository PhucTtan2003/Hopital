namespace Quản_Lý_bệnh_viện.Models
{
    public class Room
    {
        public int RoomID { get; set; }
        public int DepartmentID { get; set; }
        public string? RoomType { get; set; }
        public string? Status { get; set; }

        // Navigation properties
        public Department? Department { get; set; }
    }
}
