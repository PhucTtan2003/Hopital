using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;

namespace HospitalManagementSystem.Models
{
    public class DoctorSearchViewModel
    {
        public string SelectedSpecialty { get; set; } = "";
        public DateTime? SearchDate { get; set; } // Thêm thuộc tính này để lưu trữ ngày tìm kiếm
        public string SelectedPosition { get; set; } = "";
        public string DoctorName { get; set; } = "";

        // ImageUrl không cần giá trị mặc định trong ViewModel nếu chỉ sử dụng trong chi tiết bác sĩ
        public string ImageUrl { get; set; }

        // Để trống và sẽ được khởi tạo trong Controller
        public List<SelectListItem> Specialties { get; set; } = new List<SelectListItem>();

        // Danh sách các ngày làm việc có sẵn từ TimeSlots
        public List<SelectListItem> Dates { get; set; } = new List<SelectListItem>();

        // Để trống và sẽ được khởi tạo trong Controller
        public List<SelectListItem> Positions { get; set; } = new List<SelectListItem>();

        // Khởi tạo danh sách các bác sĩ
        public List<Doctor> Doctors { get; set; } = new List<Doctor>();
    }
}
