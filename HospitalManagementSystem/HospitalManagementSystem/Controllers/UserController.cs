using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http; // For session management
using System.Linq;
using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

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
            return View();
        }

        // POST: /Account/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Login(LoginVM model)
        {
            var account = _context.Accounts
                .FirstOrDefault(a => a.Username == model.Username && a.PasswordAccount == model.PasswordAccount);

            if (account != null)
            {
                // Successful login logic here
                HttpContext.Session.SetString("Username", model.Username); // Store username in session
                return RedirectToAction("Index", "Home");
            }

            ModelState.AddModelError("", "Invalid username or password");
            return View();
        }

        // GET: /Account/Logout
        [HttpPost]
        public async Task<IActionResult> LogOut()
        {
            // Sign out the user
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

            // Clear the session
            HttpContext.Session.Clear();

            // Redirect to the login page
            return RedirectToAction("Login", "User");
        }
    }
}
