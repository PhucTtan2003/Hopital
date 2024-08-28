using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http; // For session management
using System.Linq;
using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;

namespace Login.Controllers
{
    public class UserController : Controller
    {
        private readonly HospitalDbContext _context;

        public UserController(HospitalDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Register()
        {
            return View();
        }

        // POST: /Account/Register
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Register(Account account)
        {
            if (ModelState.IsValid)
            {
                _context.Add(account);
                _context.SaveChanges();
                return RedirectToAction(nameof(Login));
            }
            return View(account);
        }

        // GET: /Account/Login
        public IActionResult Login()
        {
            var model = new LoginVM
            {
                Roles = new List<string> { "Admin", "Khach" } // Hoặc lấy từ database nếu cần
            };
            return View(model);
        }

        // POST: /Account/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Login(LoginVM model)
        {
            if (ModelState.IsValid)
            {
                var account = _context.Accounts
                    .FirstOrDefault(a => a.Username == model.Username
                                        && a.PasswordAccount == model.PasswordAccount
                                        && a.Role == model.Role); // Kiểm tra thêm Role

                if (account != null)
                {
                    // Successful login logic here
                    HttpContext.Session.SetString("Username", model.Username); // Store username in session
                    HttpContext.Session.SetString("IsAdmin", account.Role); // Store username in session
                    return RedirectToAction("Index", "Home");
                }

                ModelState.AddModelError("", "Invalid username, password, or role");
            }

            // Khởi tạo lại danh sách Roles nếu đăng nhập thất bại
            model.Roles = new List<string> { "Admin", "Khach" }; // Hoặc lấy từ database nếu cần
            return View(model);
        }

        // GET: /Account/Logout
        public IActionResult Logout()
        {
            HttpContext.Session.Clear(); // Clear the session
            return RedirectToAction(nameof(Login));
        }
    }
}
