using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HospitalManagementSystem.Data;
using System.Linq;
using System.Threading.Tasks;

namespace HospitalManagementSystem.Controllers
{
    public class PhysiciansController : Controller
    {
        private readonly HospitalDbContext _context;

        public PhysiciansController(HospitalDbContext context)
        {
            _context = context;
        }

        // GET: Physicians/Index
        public async Task<IActionResult> Index()
        {
            var doctors = await _context.Doctors.ToListAsync();
            return View(doctors);
        }

        // GET: Physicians/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Physicians/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("FullName,Position,Specialty,DescriptionDoctor,Experience,Education,DepartmentId")] Doctor doctor, IFormFile Image)
        {
            if (ModelState.IsValid)
            {
                // Xử lý lưu file ảnh
                if (Image != null && Image.Length > 0)
                {
                    // Định nghĩa đường dẫn lưu file
                    var fileName = Path.GetFileName(Image.FileName);
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "SearchDoctor", fileName);

                    // Lưu file vào thư mục wwwroot/images
                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await Image.CopyToAsync(stream);
                    }

                    // Lưu đường dẫn ảnh vào cơ sở dữ liệu
                    doctor.ImageUrl = fileName;
                }

                // Thêm bác sĩ vào cơ sở dữ liệu
                _context.Add(doctor);
                await _context.SaveChangesAsync(); // Lưu thay đổi

                TempData["SuccessMessage"] = "Bác sĩ đã được thêm thành công!";
                return RedirectToAction(nameof(Index)); // Điều hướng về trang danh sách bác sĩ
            }

            // Nếu có lỗi, log các lỗi validation vào console
            foreach (var error in ModelState.Values.SelectMany(v => v.Errors))
            {
                Console.WriteLine(error.ErrorMessage);
            }

            return View(doctor); // Trả về view nếu có lỗi validation
        }

        // GET: Physicians/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy mã bác sĩ để chỉnh sửa!";
                return RedirectToAction(nameof(Index));
            }

            var doctor = await _context.Doctors.FindAsync(id);
            if (doctor == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy bác sĩ để chỉnh sửa!";
                return RedirectToAction(nameof(Index));
            }

            return View(doctor);
        }

        // POST: Physicians/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("DoctorId,FullName,Position,Specialty,ImageUrl,DescriptionDoctor,Experience,Education,DepartmentId")] Doctor doctor, IFormFile Image)
        {
            if (id != doctor.DoctorId)
            {
                TempData["ErrorMessage"] = "Mã bác sĩ không hợp lệ!";
                return RedirectToAction(nameof(Index));
            }

            if (ModelState.IsValid)
            {
                try
                {
                    // Xử lý tải lên hình ảnh mới
                    if (Image != null && Image.Length > 0)
                    {
                        var fileName = Path.GetFileName(Image.FileName);
                        var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "SearchDoctor", fileName);

                        // Lưu tệp hình ảnh vào thư mục wwwroot/images
                        using (var stream = new FileStream(filePath, FileMode.Create))
                        {
                            await Image.CopyToAsync(stream);
                        }

                        // Cập nhật đường dẫn hình ảnh vào trường ImageUrl
                        doctor.ImageUrl = fileName;
                    }

                    _context.Update(doctor);
                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = "Thông tin bác sĩ đã được cập nhật!";
                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DoctorExists(doctor.DoctorId))
                    {
                        TempData["ErrorMessage"] = "Không tìm thấy bác sĩ để cập nhật!";
                        return RedirectToAction(nameof(Index));
                    }
                    else
                    {
                        throw;
                    }
                }
            }

            return View(doctor);
        }

        private bool DoctorExists(int id)
        {
            return _context.Doctors.Any(e => e.DoctorId == id);
        }






        // GET: Physicians/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy mã bác sĩ để xóa!";
                return RedirectToAction(nameof(Index)); // Điều hướng về danh sách nếu không có id hợp lệ
            }

            var doctor = await _context.Doctors.FirstOrDefaultAsync(m => m.DoctorId == id);
            if (doctor == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy bác sĩ để xóa!";
                return RedirectToAction(nameof(Index)); // Điều hướng về danh sách nếu không tìm thấy bác sĩ
            }

            return View(doctor); // Trả về view để xác nhận xóa
        }

        // POST: Physicians/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var doctor = await _context.Doctors.FindAsync(id);
            if (doctor == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy bác sĩ để xóa!";
                return RedirectToAction(nameof(Index)); // Điều hướng về danh sách nếu không tìm thấy bác sĩ
            }

            _context.Doctors.Remove(doctor); // Xóa bác sĩ khỏi cơ sở dữ liệu
            await _context.SaveChangesAsync(); // Lưu thay đổi vào cơ sở dữ liệu

            TempData["SuccessMessage"] = "Bác sĩ đã được xóa thành công!";
            return RedirectToAction(nameof(Index)); // Điều hướng về trang danh sách sau khi xóa thành công
        }

    }
}