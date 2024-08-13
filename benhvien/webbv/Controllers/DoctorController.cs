using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using webbv.Data;

namespace webbv.Controllers
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
            // Lấy danh sách Doctors kèm theo Department và DoctorSearch
            var hospitalDbContext = _context.Doctors
                                             .Include(d => d.Department)
                                             .Include(d => d.DoctorSearches); // Chỉ Include nếu cần
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
    }
}