using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using TrangDoctor.Data;

namespace TrangDoctor.Models
{
    public class DoctorSearchViewModel
    {
        public string SelectedSpecialty { get; set; } = "";
        public string SelectedDay { get; set; } = "";
        public string SelectedPosition { get; set; } = "";
        public string DoctorName { get; set; } = "";

        // Chỉ cần khởi tạo `ImageUrl` khi bạn thực sự cần một giá trị mặc định
        public string ImageUrl { get; set; } = "/Images/default-doctor.jpg";

        // Khởi tạo danh sách các chuyên khoa với giá trị mặc định
        public List<SelectListItem> Specialties { get; set; } = new List<SelectListItem>
        {
            new SelectListItem { Value = "Cấp cứu", Text = "Cấp cứu" },
            new SelectListItem { Value = "Gây mê hồi sức", Text = "Gây mê hồi sức" },
            new SelectListItem { Value = "Hô hấp", Text = "Hô hấp" },
            new SelectListItem { Value = "Nội soi", Text = "Nội soi" },
            new SelectListItem { Value = "Tai-mũi-họng", Text = "Tai-mũi-họng" },
            new SelectListItem { Value = "Hồi sức tích cực", Text = "Hồi sức tích cực" },
            new SelectListItem { Value = "Tim mạch", Text = "Tim mạch" },
            new SelectListItem { Value = "Tiêu hóa", Text = "Tiêu hóa" },
        };

        // Khởi tạo danh sách các ngày trong tuần với giá trị mặc định
        public List<SelectListItem> DaysOfWeek { get; set; } = new List<SelectListItem>
        {
            new SelectListItem { Value = "Thứ hai", Text = "Thứ hai" },
            new SelectListItem { Value = "Thứ ba", Text = "Thứ ba" },
            new SelectListItem { Value = "Thứ tư", Text = "Thứ tư" },
            new SelectListItem { Value = "Thứ năm", Text = "Thứ năm" },
            new SelectListItem { Value = "Thứ sáu", Text = "Thứ sáu" },
            new SelectListItem { Value = "Thứ bảy", Text = "Thứ bảy" },
            new SelectListItem { Value = "Chủ nhật", Text = "Chủ nhật" }
        };

        // Khởi tạo danh sách các vị trí với giá trị mặc định
        public List<SelectListItem> Positions { get; set; } = new List<SelectListItem>
        {
            new SelectListItem { Value = "Bác sĩ", Text = "Bác sĩ" },
            new SelectListItem { Value = "Phó Giáo sư", Text = "Phó Giáo sư" },
            new SelectListItem { Value = "Giáo sư", Text = "Giáo sư" }
        };

        // Khởi tạo danh sách các bác sĩ
        public List<Doctor> Doctors { get; set; } = new List<Doctor>();
    }
}
