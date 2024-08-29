using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Mvc.Rendering;
using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;
using Microsoft.EntityFrameworkCore;

namespace SearchingDoctorController.Controllers
{
    public class SearchingDoctorController : Controller
    {
        private readonly HospitalDbContext _context;

        // Constructor nhận DbContext để tương tác với cơ sở dữ liệu
        public SearchingDoctorController(HospitalDbContext context)
        {
            _context = context;
        }

        // Action xử lý GET request để hiển thị trang tìm kiếm bác sĩ
        [HttpGet]
        public IActionResult Search()
        {
            // Khởi tạo ViewModel và thiết lập các danh sách chọn (dropdown lists)
            var viewModel = new DoctorSearchViewModel
            {
                // Lấy dữ liệu từ bảng Doctors, tạo danh sách dropdown với các chuyên khoa
                Specialties = _context.Doctors
                    .GroupBy(d => d.Specialty)
                    .Select(g => new SelectListItem
                    {
                        Value = g.Key,
                        Text = g.Key
                    }).ToList(),

                // Lấy dữ liệu từ bảng TimeSlots để tạo danh sách dropdown với các ngày có lịch khám
                Dates = _context.TimeSlots
                    .GroupBy(ts => ts.Date)
                    .Select(g => new SelectListItem
                    {
                        Value = g.Key.ToString("yyyy-MM-dd"),  // Chuyển đổi DateTime thành chuỗi
                        Text = g.Key.ToString("dd/MM/yyyy")
                    }).ToList(),

                // Lấy dữ liệu từ bảng Doctors để tạo danh sách dropdown với học vị (Position)
                Positions = _context.Doctors
                    .GroupBy(d => d.Position)
                    .Select(g => new SelectListItem
                    {
                        Value = g.Key,
                        Text = g.Key
                    }).ToList()
            };

            // Trả về View với ViewModel đã được khởi tạo
            return View(viewModel);
        }

        // Action xử lý POST request để thực hiện tìm kiếm bác sĩ dựa trên các tiêu chí từ ViewModel
        [HttpPost]
        public IActionResult Search(DoctorSearchViewModel model)
        {
            // Khởi tạo truy vấn với bảng Doctors
            var doctorsQuery = _context.Doctors
                .Include(d => d.TimeSlots) // Bao gồm cả TimeSlots để tìm kiếm
                .AsQueryable();

            // Lọc theo chuyên khoa nếu người dùng chọn chuyên khoa
            if (!string.IsNullOrEmpty(model.SelectedSpecialty))
            {
                doctorsQuery = doctorsQuery.Where(d => d.Specialty == model.SelectedSpecialty);
            }

            // Lọc theo ngày khám nếu người dùng chọn ngày khám
            if (model.SearchDate.HasValue)
            {
                doctorsQuery = doctorsQuery.Where(d => d.TimeSlots.Any(ts => ts.Date.Date == model.SearchDate.Value.Date));
            }

            // Lọc theo học vị (Position) nếu người dùng chọn
            if (!string.IsNullOrEmpty(model.SelectedPosition))
            {
                doctorsQuery = doctorsQuery.Where(d => d.Position == model.SelectedPosition);
            }

            // Lọc theo tên bác sĩ nếu người dùng nhập tên bác sĩ
            if (!string.IsNullOrEmpty(model.DoctorName))
            {
                doctorsQuery = doctorsQuery.Where(d => d.FullName.Contains(model.DoctorName));
            }

            // Lưu kết quả tìm kiếm vào ViewModel
            model.Doctors = doctorsQuery.ToList();

            // Lấy lại danh sách dropdown để tránh lỗi null reference trong view
            model.Specialties = _context.Doctors
                .GroupBy(d => d.Specialty)
                .Select(g => new SelectListItem
                {
                    Value = g.Key,
                    Text = g.Key
                }).ToList();

            model.Dates = _context.TimeSlots
                .GroupBy(ts => ts.Date)
                .Select(g => new SelectListItem
                {
                    Value = g.Key.ToString("yyyy-MM-dd"),
                    Text = g.Key.ToString("dd/MM/yyyy")
                }).ToList();

            model.Positions = _context.Doctors
                .GroupBy(d => d.Position)
                .Select(g => new SelectListItem
                {
                    Value = g.Key,
                    Text = g.Key
                }).ToList();

            // Nếu yêu cầu là AJAX, trả về PartialView với kết quả tìm kiếm
            if (Request.IsAjaxRequest())
            {
                return PartialView("_SearchResults", model);
            }

            // Nếu không, trả về View với ViewModel đã có kết quả
            return View(model);
        }

        // Action xử lý GET request để hiển thị chi tiết bác sĩ
        [HttpGet]
        public IActionResult Detail(int id)
        {
            // Tìm bác sĩ theo Id
            var doctor = _context.Doctors
                .Include(d => d.TimeSlots) // Bao gồm cả TimeSlots để hiển thị chi tiết
                .FirstOrDefault(d => d.DoctorId == id);

            if (doctor == null)
            {
                return NotFound(); // Trả về lỗi 404 nếu không tìm thấy bác sĩ
            }

            // Thiết lập đường dẫn ảnh nếu không có ảnh, sử dụng ảnh mặc định
            doctor.ImageUrl = string.IsNullOrEmpty(doctor.ImageUrl)
                ? "/images/default-doctor.jpg"  // Đường dẫn tới ảnh mặc định nếu không có ảnh
                : $"/images/{doctor.ImageUrl}";

            // Trả về View chi tiết với dữ liệu bác sĩ
            return View(doctor);
        }
    }

    // Lớp mở rộng để kiểm tra xem yêu cầu có phải là AJAX không
    public static class HttpRequestExtensions
    {
        public static bool IsAjaxRequest(this Microsoft.AspNetCore.Http.HttpRequest request)
        {
            // Kiểm tra header X-Requested-With để xác định nếu yêu cầu là AJAX
            return request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }
    }
}
