using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HospitalManagementSystem.Controllers
{
    public class DoctorController : Controller
    {
        private readonly HospitalDbContext _context;

        public DoctorController(HospitalDbContext context)
        {
            _context = context;
        }

        // GET: Doctors
        public async Task<IActionResult> Index()
        {
            var hospitalDbContext = _context.Doctors
                                             .Include(d => d.Department);

            // Nếu bạn cần DoctorSearches thì chỉ Include khi thực sự cần thiết
            return View(await hospitalDbContext.ToListAsync());
        }

        // GET: Doctors/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var doctor = await _context.Doctors
                                       .Include(d => d.Department)
                                       .Include(d => d.DoctorSearches) // Include nếu cần DoctorSearch
                                       .FirstOrDefaultAsync(m => m.DoctorId == id);
            if (doctor == null)
            {
                return NotFound();
            }

            return View(doctor);
        }

        //Doctor/CapCuuEmergency - Trang Tĩnh nên Không lấy dữ liệu từ database
        public IActionResult CapCuuEmergency()
        {
            return View();
        }

        //Doctor/GayMeHoiSuc
        public IActionResult GayMeHoiSuc()
        {
            return View();
        }

        public IActionResult HoHapRespiratory()
        {
            return View();
        }

        public IActionResult NoiSoiEndoscopy()
        {
            return View();
        }

        public IActionResult TaiMuiHongOtolaryngology()
        {
            return View();
        }

        public IActionResult HoiSucTichCucIntensiveCare()
        {
            return View();
        }

        public IActionResult TimMachCardiology()
        {
            return View();
        }

        public IActionResult TieuHoaGastroenterology()
        {
            return View();
        }

    }
}
