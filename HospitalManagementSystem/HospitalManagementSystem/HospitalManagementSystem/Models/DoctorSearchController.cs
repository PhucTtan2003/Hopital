using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;

namespace HospitalManagementSystem.Models
{
    public class DoctorSearchViewModel
    {
        public string SelectedSpecialty { get; set; } = "";
        public string SelectedDay { get; set; } = "";
        public string SelectedPosition { get; set; } = "";
        public string DoctorName { get; set; } = "";

        // ImageUrl không cần giá trị mặc định trong ViewModel nếu chỉ sử dụng trong chi tiết bác sĩ
        public string ImageUrl { get; set; }

        // Để trống và sẽ được khởi tạo trong Controller
        public List<SelectListItem> Specialties { get; set; } = new List<SelectListItem>();

        // Khởi tạo danh sách các ngày trong tuần
        public List<SelectListItem> DaysOfWeek { get; set; } = new List<SelectListItem>
        {
            new SelectListItem { Value = "Monday", Text = "Thứ hai" },
            new SelectListItem { Value = "Tuesday", Text = "Thứ ba" },
            new SelectListItem { Value = "Wednesday", Text = "Thứ tư" },
            new SelectListItem { Value = "Thursday", Text = "Thứ năm" },
            new SelectListItem { Value = "Friday", Text = "Thứ sáu" },
            new SelectListItem { Value = "Saturday", Text = "Thứ bảy" },
            new SelectListItem { Value = "Sunday", Text = "Chủ nhật" }
        };

        // Để trống và sẽ được khởi tạo trong Controller
        public List<SelectListItem> Positions { get; set; } = new List<SelectListItem>();

        // Khởi tạo danh sách các bác sĩ
        public List<Doctor> Doctors { get; set; } = new List<Doctor>();
    }
}
