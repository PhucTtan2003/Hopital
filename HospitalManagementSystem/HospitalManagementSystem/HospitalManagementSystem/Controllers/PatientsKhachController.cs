using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Linq;
using System.Threading.Tasks;

namespace HospitalManagementSystem.Controllers
{
    public class PatientsKhachController : Controller
    {
        private readonly HospitalDbContext _context;

        public PatientsKhachController(HospitalDbContext context)
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
        public async Task<IActionResult> Create([Bind("FirstName,LastName,DateOfBirth,Gender,AddressPatients,Phone,Email")] Patient patient)
        {
            // Lấy AccountId từ session
            var accountId = HttpContext.Session.GetString("AccountId");

            if (accountId == null)
            {
                return RedirectToAction("Login", "Account");
            }

            if (ModelState.IsValid)
            {
                // Gán AccountId từ session vào patient
                patient.AccountId = int.Parse(accountId);

                // Set thêm CreatedAt với thời gian hiện tại
                patient.CreatedAt = DateTime.Now;

                // Lưu bệnh nhân vào cơ sở dữ liệu
                _context.Add(patient);
                await _context.SaveChangesAsync();

                // Chuyển hướng về trang Index sau khi tạo thành công
                return RedirectToAction(nameof(Index));
            }

            // Trả về view nếu có lỗi validation
            return View(patient);
        }


        // GET: Patient/Index
        public ActionResult Index()
        {
            var uname = HttpContext.Session.GetString("Username");
            var Id = HttpContext.Session.GetString("AccountId");
            var role = HttpContext.Session.GetString("Roles");
            if(role == "khach")
            {
                var profiles = _context.Patients.Where(u => u.AccountId.ToString() == Id).ToList();
                return View(profiles);
            }
            
            return View();
        }
        public ActionResult Continue(int id, Patient patient)
        {
            TempData["patient"] = id;
            return RedirectToAction("SelectSpecialty", id);
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
        public IActionResult BookAppointment(string specialty, Patient patient)
        {
            TempData["Specialty"] = specialty;
            return RedirectToAction("SelectDoctor"); // Chuyển đến SelectDoctor
        }
        // GET: Patient/SelectSpecialty
        public async Task<IActionResult> SelectSpecialty(Patient patient)
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

        public async Task<IActionResult> SelectDoctor()
        {
            var specialty = TempData["Specialty"] as string;
            if (string.IsNullOrEmpty(specialty))
            {
                return RedirectToAction("Error", new { message = "Chuyên khoa không được xác định." });
            }

            var doctors = await _context.Doctors
                                        .Where(d => d.Specialty == specialty)
                                        .ToListAsync();

            if (doctors.Count == 0)
            {
                return RedirectToAction("Error", new { message = "Không tìm thấy bác sĩ nào cho chuyên khoa này." });
            }

            TempData["Doctors"] = JsonConvert.SerializeObject(doctors); // Lưu danh sách bác sĩ vào TempData
            TempData["Specialty"] = specialty; // Lưu specialty

            return View(doctors);
        }

        public async Task<IActionResult> SelectTimeSlot(int doctorId)
        {
            var timeSlots = await _context.TimeSlots
                                          .Where(t => t.DoctorId == doctorId && t.IsAvailable)
                                          .ToListAsync();

            if (timeSlots.Count == 0)
            {
                return RedirectToAction("Error", new { message = "Không có khung giờ nào có sẵn cho bác sĩ này." });
            }

            TempData["DoctorId"] = doctorId; // Lưu DoctorId vào TempData
            TempData["TimeSlots"] = JsonConvert.SerializeObject(timeSlots); // Lưu danh sách thời gian vào TempData

            return View(timeSlots);
        }
    }
}