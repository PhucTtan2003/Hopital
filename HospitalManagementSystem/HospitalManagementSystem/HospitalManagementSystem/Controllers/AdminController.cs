using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HospitalManagementSystem.Controllers
{
    [Authorize(Roles = "admin")]  // Chỉ cho phép người dùng với vai trò 'admin' truy cập
    public class AdminController : Controller
    {
        private readonly HospitalDbContext _context;

        // Constructor với Dependency Injection để khởi tạo _context
        public AdminController(HospitalDbContext context)
        {
            _context = context;
        }

        // Trang dashboard admin
        public IActionResult Index()
        {
            return View();
        }

        // Trang hồ sơ admin
        public IActionResult Profile()
        {
            return View();
        }

        // Đăng xuất
        [Authorize]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Index", "Home");
        }
        public IActionResult Dashboard(DateTime? startDate, DateTime? endDate)
        {
            if (!startDate.HasValue || !endDate.HasValue)
            {
                // Nếu không có ngày, mặc định là 7 ngày gần đây
                startDate = DateTime.Today.AddDays(-7);
                endDate = DateTime.Today;
            }

            // Lọc bệnh nhân theo khoảng thời gian đã chọn
            var patientsByDate = _context.Patients
                .Where(p => p.CreatedAt >= startDate && p.CreatedAt <= endDate)
                .GroupBy(p => p.CreatedAt.Value.Date)
                .Select(g => new
                {
                    Date = g.Key,
                    Count = g.Count()
                })
                .ToList();

            // Truyền dữ liệu vào ViewBag để sử dụng trong View
            ViewBag.PatientDates = patientsByDate.Select(p => p.Date.ToString("yyyy-MM-dd")).ToList();
            ViewBag.PatientCounts = patientsByDate.Select(p => p.Count).ToList();

            return View();
        }


    }
}