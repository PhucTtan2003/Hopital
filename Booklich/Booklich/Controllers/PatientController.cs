using Booklich.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace Booklich.Controllers
{
    public class PatientController : Controller
    {
        private readonly HospitalDbContext _context;

        public PatientController(HospitalDbContext context)
        {
            _context = context;
        }

        // GET: Patient/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Patient/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Patient patient)
        {
            if (ModelState.IsValid)
            {
                _context.Patients.Add(patient);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(patient);
        }

        // GET: Patient/Index
        public ActionResult Index()
        {
            var profiles = _context.Patients.ToList();
            return View(profiles);
        }

        // GET: Patient/Edit/5
        public ActionResult Edit(int id)
        {
            var patient = _context.Patients.Find(id);
            if (patient == null)
            {
                return NotFound();
            }
            return View(patient);
        }

        // POST: Patient/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, Patient patient)
        {
            if (id != patient.PatientId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(patient);
                    _context.SaveChanges();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!PatientExists(patient.PatientId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(patient);
        }

        // GET: Patient/Delete/5
        public ActionResult Delete(int id)
        {
            var patient = _context.Patients
                .FirstOrDefault(m => m.PatientId == id);
            if (patient == null)
            {
                return NotFound();
            }

            return View(patient);
        }

        // POST: Patient/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var patient = _context.Patients.Find(id);
            _context.Patients.Remove(patient);
            _context.SaveChanges();
            return RedirectToAction(nameof(Index));
        }

        private bool PatientExists(int id)
        {
            return _context.Patients.Any(e => e.PatientId == id);
        }
        [HttpPost]
        public IActionResult BookAppointment(string specialty)
        {
            // Redirect to the SelectDoctor action with the chosen specialty
            return RedirectToAction("SelectDoctor", new { specialty });
        }
        // GET: Patient/SelectSpecialty
        public async Task<IActionResult> SelectSpecialty()
        {
            // Retrieve all specialties from the database
            var specialties = await _context.SelectSpecialties
                                            .Select(s => s.Specialty)
                                            .ToListAsync();

            if (specialties == null || specialties.Count == 0)
            {
                return RedirectToAction("Error", new { message = "Không tìm thấy chuyên khoa." });
            }

            return View(specialties);
        }

        public async Task<IActionResult> SelectDoctor(string specialty)
        {
            // Retrieve all doctors with the selected specialty
            var doctors = await _context.Doctors
                                        .Where(d => d.Specialty == specialty)
                                        .ToListAsync();

            if (doctors.Count == 0)
            {
                return RedirectToAction("Error", new { message = "Không tìm thấy bác sĩ nào cho chuyên khoa này." });
            }

            ViewBag.Specialty = specialty;
            return View(doctors);
        }
        public async Task<IActionResult> SelectTimeSlot(int doctorId, int patientId)
        {
            // Retrieve all available time slots for the selected doctor
            var timeSlots = await _context.TimeSlots
                                          .Where(t => t.DoctorId == doctorId && t.IsAvailable)
                                          .ToListAsync();

            if (timeSlots.Count == 0)
            {
                return RedirectToAction("Error", new { message = "Không có khung giờ nào có sẵn cho bác sĩ này." });
            }

            ViewBag.DoctorID = doctorId;
            ViewBag.PatientID = patientId;
            return View(timeSlots);

        }

    }
}
