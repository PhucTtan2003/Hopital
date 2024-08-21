using Booklich.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.Elfie.Diagnostics;
using Microsoft.EntityFrameworkCore;

namespace Booklich.Controllers
{
    public class DoctorController : Controller
    {
        private readonly HospitalDbContext _context;

        public DoctorController(HospitalDbContext context)
        {
            _context = context;
        }

        public ActionResult Index(string searchString, string specialty, string position)
        {
            var doctors = from d in _context.Doctors
                          select d;

            if (!String.IsNullOrEmpty(searchString))
            {
                doctors = doctors.Where(s => s.FullName.Contains(searchString));
            }

            if (!String.IsNullOrEmpty(specialty))
            {
                doctors = doctors.Where(x => x.Specialty == specialty);
            }
            if (!String.IsNullOrEmpty(position))
            {
                doctors = doctors.Where(x => x.Position == position);
            }
            return View(doctors.ToList());
        }
    }
}
