using HospitalManagementSystem.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
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

        //Admin Xem Nhân Viên
        // GET: StaffList
        public async Task<IActionResult> StaffList(string searchTerm)
        {
            var staffList = _context.Staff.AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                staffList = staffList.Where(s => s.FirstName.Contains(searchTerm) || s.LastName.Contains(searchTerm));
            }

            return View(await staffList.Include(s => s.Department).ToListAsync());
        }

        //Thêm Nhân Viên
        // GET: Patient/Create
        public ActionResult Create()
        {
            var department = _context.Departments.FirstOrDefault();

            if (department != null)
            {
                ViewBag.DepartmentId = new SelectList(_context.Departments, "DepartmentId", "DepartmentName", department.DepartmentId);
            }
            else
            {
                // Handle case when no department is found, such as initializing an empty list or showing a message
                ViewBag.DepartmentId = new SelectList(_context.Departments, "DepartmentId", "DepartmentName");
            }

            return View();
        }


        // POST: Staff/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Staff staff)
        {
            _context.Staff.Add(staff);
            _context.SaveChanges();
            return RedirectToAction("StaffList");
        }


        // GET: Edit
        [HttpGet]
        public IActionResult Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var staff = _context.Staff.Include(s => s.Department).FirstOrDefault(s => s.StaffId == id);
            if (staff == null)
            {
                return NotFound();
            }
            ViewBag.DepartmentId = new SelectList(_context.Departments, "DepartmentId", "DepartmentName", staff.DepartmentId);
            return View(staff);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("StaffId,FirstName,LastName,Position,DepartmentId,Phone,Email")] Staff staff)
        {
            if (id != staff.StaffId)
            {
                return NotFound();
            }

            try
            {
                _context.Update(staff);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Cập nhật nhân viên thành công!";
                return RedirectToAction("StaffList");
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!StaffExists(staff.StaffId))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            ViewBag.DepartmentId = new SelectList(_context.Departments, "DepartmentId", "DepartmentName", staff.DepartmentId);
            return View(staff);
        }


        private bool StaffExists(int id)
        {
            return _context.Staff.Any(e => e.StaffId == id);
        }

        // POST: Delete
        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var staff = await _context.Staff.FindAsync(id);
            if (staff != null)
            {
                _context.Staff.Remove(staff);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(StaffList));
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
        // Tính tổng số bệnh nhân
        public IActionResult Total()
        {
            // Tính tổng số bệnh nhân
            var totalPatients = _context.Patients.Count();

            // Lấy danh sách bệnh nhân từ cơ sở dữ liệu
            var patients = _context.Patients.ToList();

            // Truyền cả danh sách bệnh nhân và tổng số bệnh nhân đến ViewBag
            ViewBag.TotalPatients = totalPatients;

            return View(patients);
        }
        //Xuất File TXT
        public IActionResult ExportToText()
        {
            var patients = _context.Patients.ToList();

            // Sử dụng StringBuilder để tạo chuỗi văn bản
            var stringBuilder = new System.Text.StringBuilder();

            // Tiêu đề của các cột
            stringBuilder.AppendLine("First Name, Last Name, Date of Birth, Gender, Address, Phone, Email, Created At, Account Id");

            // Thêm từng bệnh nhân vào file
            foreach (var patient in patients)
            {
                stringBuilder.AppendLine(
                    $"{patient.FirstName}, {patient.LastName}, " +
                    $"{patient.DateOfBirth?.ToString("dd/MM/yyyy")}, {patient.Gender}, " +
                    $"{patient.AddressPatients}, {patient.Phone}, {patient.Email}, " +
                    $"{patient.CreatedAt?.ToString("dd/MM/yyyy")}, {patient.Account?.AccountId}"
                );
            }

            // Chuyển đổi dữ liệu chuỗi thành mảng byte để tải xuống
            var bytes = System.Text.Encoding.UTF8.GetBytes(stringBuilder.ToString());
            return File(bytes, "text/plain", "PatientsList.txt");
        }




    }
}