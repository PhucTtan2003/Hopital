using Microsoft.AspNetCore.Mvc;
using TrangDoctor.Data;
using TrangDoctor.Models;
using System.Linq;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace TrangDoctor.Controllers
{
    public class DoctorController : Controller
    {
        private readonly HospitalDbContext _context;

        public DoctorController(HospitalDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Search()
        {
            var viewModel = new DoctorSearchViewModel
            {
                // Lấy dữ liệu từ bảng SelectSpecialty thay vì Specialties
                Specialties = _context.SelectSpecialties.Select(s => new SelectListItem
                {
                    Value = s.Specialty,
                    Text = s.Specialty
                }).ToList(),
                DaysOfWeek = new List<SelectListItem>
        {
            new SelectListItem { Value = "Monday", Text = "Thứ hai" },
            new SelectListItem { Value = "Tuesday", Text = "Thứ ba" },
            new SelectListItem { Value = "Wednesday", Text = "Thứ tư" },
            new SelectListItem { Value = "Thursday", Text = "Thứ năm" },
            new SelectListItem { Value = "Friday", Text = "Thứ sáu" },
            new SelectListItem { Value = "Saturday", Text = "Thứ bảy" },
            new SelectListItem { Value = "Sunday", Text = "Chủ nhật" }
        },
                Positions = new List<SelectListItem>
        {
            new SelectListItem { Value = "Professor", Text = "Giáo sư" },
            new SelectListItem { Value = "Associate Professor", Text = "Phó Giáo sư" },
            new SelectListItem { Value = "Doctor", Text = "Bác sĩ" }
        }
            };
            return View(viewModel);
        }


        [HttpPost]
        public IActionResult Search(DoctorSearchViewModel model)
        {
            var doctors = _context.Doctors.AsQueryable();

            if (!string.IsNullOrEmpty(model.SelectedSpecialty))
            {
                doctors = doctors.Where(d => d.Specialty == model.SelectedSpecialty);
            }

            if (!string.IsNullOrEmpty(model.SelectedDay))
            {
                doctors = doctors.Where(d => d.Appointments
                    .Any(a => a.AppointmentDate.ToDateTime(TimeOnly.MinValue).DayOfWeek.ToString() == model.SelectedDay));
            }

            if (!string.IsNullOrEmpty(model.SelectedPosition))
            {
                doctors = doctors.Where(d => d.Position == model.SelectedPosition);
            }

            if (!string.IsNullOrEmpty(model.DoctorName))
            {
                doctors = doctors.Where(d => d.FullName.Contains(model.DoctorName));
            }

            model.Doctors = doctors.ToList();

            if (Request.IsAjaxRequest()) // Kiểm tra nếu là yêu cầu AJAX
            {
                return PartialView("_SearchResults", model);
            }

            return View(model);
        }

        [HttpGet]
        public IActionResult Details(int id)
        {
            var doctor = _context.Doctors.FirstOrDefault(d => d.DoctorId == id);
            if (doctor == null)
            {
                return NotFound(); // Trả về lỗi 404 nếu không tìm thấy bác sĩ
            }

            doctor.ImageUrl = string.IsNullOrEmpty(doctor.ImageUrl)
                              ? "/Images/default-doctor.jpg"  // Đường dẫn tới ảnh mặc định nếu không có ảnh
                              : $"/Images/{doctor.ImageUrl}";

            return View(doctor); // Trả về view chi tiết với dữ liệu bác sĩ
        }
    }

    public static class HttpRequestExtensions
    {
        public static bool IsAjaxRequest(this Microsoft.AspNetCore.Http.HttpRequest request)
        {
            return request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }
    }
}
