 using Microsoft.AspNetCore.Mvc;
using webbv.Data;

namespace webbv.Controllers
{
    public class SpecialtyController : Controller
    {
        private readonly HospitalDbContext _context;

        public SpecialtyController(HospitalDbContext context)
        {
            _context = context;
        }
        public IActionResult Index()
        {
            return View();
        }   
        public IActionResult SelectSpecialty(int patientId)
        {
            ViewBag.PatientId = patientId;
            return View();
        }
      
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SelectSpecialty(int patientId, string specialty)
        {
            var selectSpecialty = new SelectSpecialty
            {
                PatientId = patientId,
                Specialty = specialty
            };

            _context.SelectSpecialties.Add(selectSpecialty);
            await _context.SaveChangesAsync();

            return RedirectToAction("Index", "Patients");
        }
    }
}
