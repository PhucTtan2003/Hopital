using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http; // For session management
using System.Linq;
using System.Threading.Tasks;
using HospitalManagementSystem.Models;
using HospitalManagementSystem.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;

namespace Login.Controllers
{
    public class UserController : Controller
    {
        private readonly HospitalDbContext _context;

        public UserController(HospitalDbContext context)
        {
            _context = context;
        }

        // GET: /User/Register
        public IActionResult Register()
        {
            return View();
        }

        // POST: /User/Register
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(LoginVM model)
        {
            if (ModelState.IsValid)
            {
                // Kiểm tra nếu Username đã tồn tại
                if (_context.Accounts.Any(a => a.Username == model.Username))
                {
                    ModelState.AddModelError("Username", "Username already exists.");
                    return View(model);
                }

                // Kiểm tra và đảm bảo Role hợp lệ (admin hoặc khach)
                var validRoles = new List<string> { "admin", "khach" };
                if (!validRoles.Contains(model.Roles.ToLower()))
                {
                    ModelState.AddModelError("Roles", "Role must be either 'Admin' or 'khach'.");
                    return View(model);
                }

                // Tạo tài khoản mới
                var newUser = new Account
                {
                    Username = model.Username,
                    PasswordAccount = model.PasswordAccount,  // Bạn nên mã hóa mật khẩu trước khi lưu vào CSDL
                    Roles = model.Roles.ToLower()  // Lưu vai trò người dùng đã nhập, viết thường
                };

                _context.Accounts.Add(newUser);
                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Account created successfully. Please login.";
                return RedirectToAction("Login", "User");
            }

            return View(model);
        }


        // GET: /User/Login
        public IActionResult Login()
        {
            return View();
        }
        // POST: /User/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginVM model)
        {
            if (ModelState.IsValid)
            {
                var user = await _context.Accounts.FirstOrDefaultAsync(u =>
                    u.Username == model.Username &&
                    u.PasswordAccount == model.PasswordAccount);

                if (user != null)
                {
                    // Lưu thông tin người dùng vào session
                    HttpContext.Session.SetString("AccountId", user.AccountId.ToString());
                    HttpContext.Session.SetString("Username", user.Username);
                    HttpContext.Session.SetString("Roles", user.Roles.ToLower());

                    // Đăng nhập người dùng
                    var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Role, user.Roles.ToLower())
            };

                    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity));

                    // Điều hướng dựa trên vai trò người dùng
                    if (user.Roles.ToLower() == "admin")
                    {
                        return RedirectToAction("Index", "Admin");
                    }
                    else if (user.Roles.ToLower() == "khach")
                    {
                        TempData["SuccessMessage"] = "Đăng nhập thành công!";
                        return RedirectToAction("Index", "Home");
                    }
                }
                else
                {
                    TempData["ErrorMessage"] = "Username hoặc mật khẩu không chính xác.";
                    return RedirectToAction("Login");
                }
            }
            return View(model);
        }

        private IActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "Home");
            }
        }



        [Authorize]
        public IActionResult UserProfile()
        {
            var username = HttpContext.Session.GetString("Username");
            var user = _context.Accounts.FirstOrDefault(a => a.Username == username);

            if (user == null)
            {
                return RedirectToAction("Login");
            }

            return View(user);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public IActionResult UserProfile(Account model)
        {
            if (ModelState.IsValid)
            {
                var user = _context.Accounts.FirstOrDefault(a => a.AccountId == model.AccountId);
                if (user != null)
                {
                    user.Username = model.Username;
                    user.PasswordAccount = model.PasswordAccount;

                    _context.SaveChanges();
                    TempData["SuccessMessage"] = "Thông tin cá nhân đã được cập nhật.";
                }
            }

            return View(model);
        }

        [Authorize(Roles = "admin")]
        public IActionResult ManageUsers()
        {
            // Chỉ những người dùng với vai trò "admin" mới có thể truy cập vào đây.
            return View();
        }

        [Authorize(Roles = "khach")]
        public IActionResult ViewAppointments()
        {
            var username = HttpContext.Session.GetString("Username");
            var account = _context.Accounts.FirstOrDefault(a => a.Username == username);

            if (account != null)
            {
                var patient = _context.Patients.FirstOrDefault(p => p.AccountId == account.AccountId);
                if (patient != null)
                {
                    var appointments = _context.Appointments
                                               .Where(a => a.PatientId == patient.PatientId)
                                               .ToList();
                    return View(appointments);
                }
            }

            return View(new List<Appointment>());
        }

        [Authorize]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Index","Home");
        }
    }
}