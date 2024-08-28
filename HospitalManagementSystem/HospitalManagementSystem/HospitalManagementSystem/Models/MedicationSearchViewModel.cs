using HospitalManagementSystem.Data;
using System.Collections.Generic;

namespace HospitalManagementSystem.Models
{
    // ViewModel cho trang tìm kiếm thuốc
    public class MedicationSearchViewModel
    {
        // Từ khóa tìm kiếm mà người dùng nhập vào
        public string SearchTerm { get; set; }

        // Danh sách các loại thuốc được tìm thấy
        public IEnumerable<Medication> Medications { get; set; }
    }

    // Đối tượng đại diện cho một loại thuốc trong giỏ hàng
    public class CartItem
    {
        // ID của thuốc
        public int MedicationId { get; set; }

        // Tên của thuốc
        public string MedicationName { get; set; }

        // Đường dẫn tới hình ảnh của thuốc
        public string MedicationImage { get; set; }

        // Giá của thuốc
        public decimal Price { get; set; }

        // Số lượng thuốc trong giỏ hàng
        public int Quantity { get; set; }

        // Tính tổng giá trị của thuốc dựa trên giá và số lượng
        public decimal Total => Price * Quantity;
    }
}
