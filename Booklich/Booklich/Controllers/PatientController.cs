using Booklich.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;

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
        // GET: Patient/SelectDoctor/5
        public ActionResult SelectDoctor(int id, string searchQuery)
        {
            var patient = _context.Patients.Find(id);
            if (patient == null)
            {
                return NotFound();
            }

            ViewBag.PatientID = id;

            // Filter doctors based on the search query
            var doctors = _context.Doctors.AsQueryable();

            if (!string.IsNullOrEmpty(searchQuery))
            {
                doctors = doctors.Where(d => d.FullName.Contains(searchQuery) || d.Specialty.Contains(searchQuery));
            }

            return View(doctors.ToList());
        }

        public ActionResult BookAppointment(int patientId, int doctorId)
        {
            // Logic to book an appointment with the selected doctor for the patient

            // Redirect to the appointment confirmation or details page
            return RedirectToAction("ConfirmAppointment", new { patientId, doctorId });
        }

        // GET: Patient/BookAppointment?patientId=1&doctorId=2


    }
}
