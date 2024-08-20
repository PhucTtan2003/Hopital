using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;
using Microsoft.AspNetCore.Mvc;

namespace HospitalManagementSystem.Controllers
{
    public class IntroduceController : Controller
    {
        private readonly HospitalDbContext _context;

        public IntroduceController(HospitalDbContext context)
        {
            _context = context;
        }

        // Trang Giới thiệu tổng quan
        public IActionResult GioiThieu()
        {
            return View();
        }

        // Trang Tầm nhìn - Sứ mệnh - Giá trị cốt lõi
        public IActionResult TamNhinSuMechCotLoi()
        {
            return View();
        }

        // Trang Lịch sử Bệnh viện
        public IActionResult LichSu()
        {
            return View();
        }

        // Trang Ban lãnh đạo
        public IActionResult BanLanhDao()
        {
            return View();
        }

        // Trang Thành tựu và chất lượng
        public IActionResult ThanhTuu()
        {
            return View();
        }

        // Trang Thông tin liên hệ
        public IActionResult ThongTinLienHe()
        {
            return View();
        }
    }
}
