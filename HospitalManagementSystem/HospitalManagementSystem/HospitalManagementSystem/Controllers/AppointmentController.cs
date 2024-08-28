using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace HospitalManagementSystem.Controllers
{
    public class AppointmentController : Controller
    {
        private readonly HospitalDbContext _context;
        public AppointmentController (HospitalDbContext context)
        {
            _context = context;
        }

        public ActionResult Index()
        {
            var appointments = _context.Appointments
                .Select(a => new AppointmentViewModel
                {
                    AppointmentId = a.AppointmentId,
                    DoctorName = a.Doctor.FullName,
                    PatientName = a.Patient.LastName,
                   
                    Notes = a.Notes,
                })
                .ToList();

            return View(appointments);
        }
        public IActionResult Create()
        {
            ViewBag.PatientId = new SelectList(_context.Patients, "PatientId", "LastName");
            ViewBag.DoctorId = new SelectList(_context.Doctors, "DoctorId", "FullName");
            ViewBag.DepartmentId = new SelectList(_context.Departments, "DepartmentId", "DepartmentName");
            return View();
        }
        [HttpPost]
        public IActionResult Create(Appointment appointment)
        {
            try
            {
                _context.Add(appointment);
                _context.SaveChanges();
            }
            catch (Exception ex) { }
            return RedirectToAction("Index","Home");
        }
    }
}
