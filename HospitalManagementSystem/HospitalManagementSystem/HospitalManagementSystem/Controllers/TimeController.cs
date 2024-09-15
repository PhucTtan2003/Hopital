using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace HospitalManagementSystem.Controllers
{
    public class TimeController : Controller
    {
        private readonly HospitalDbContext _context;

        public TimeController(HospitalDbContext context)
        {
            _context = context;
        }

        // GET: Time/Create
        public IActionResult Create()
        {
            // Lấy danh sách bác sĩ để hiển thị trong dropdown
            ViewData["Doctors"] = new SelectList(_context.Doctors, "DoctorId", "FullName");
            return View();
        }

        // POST: Time/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("DoctorId,Date,Time,IsAvailable")] TimeSlot timeSlot)
        {
            {
                // Lưu thời gian rảnh của bác sĩ vào cơ sở dữ liệu
                _context.Add(timeSlot);
                await _context.SaveChangesAsync();

                // Thêm thông báo thành công và chuyển hướng tới trang Index (danh sách TimeSlots)
                TempData["SuccessMessage"] = "Thời gian rảnh của bác sĩ đã được thêm thành công!";
                return RedirectToAction(nameof(Index));  // Chuyển hướng về Index sau khi lưu thành công
            }
        }



        // GET: Time/Index
        public async Task<IActionResult> Index()
        {
            // Lấy danh sách thời gian rảnh kèm thông tin bác sĩ
            var timeSlots = await _context.TimeSlots.Include(t => t.Doctor).ToListAsync();

            // Trả về view kèm theo danh sách các timeslot
            return View(timeSlots);
        }
    }
}
