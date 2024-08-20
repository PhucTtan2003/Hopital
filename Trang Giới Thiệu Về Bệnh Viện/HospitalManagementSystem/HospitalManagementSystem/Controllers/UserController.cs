using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http; // For session management
using System.Linq;
using HospitalManagementSystem.Data;

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
        public IActionResult Login(string username, string password)
        {
            var account = _context.Accounts
                .FirstOrDefault(a => a.Username == username && a.PasswordAccount == password);

            if (account != null)
            {
                // Successful login logic here
                HttpContext.Session.SetString("Username", username); // Store username in session
                return RedirectToAction("Index", "Home");
            }

            ModelState.AddModelError("", "Invalid username or password");
            return View();
        }

        // GET: /Account/Logout
        public IActionResult Logout()
        {
            HttpContext.Session.Clear(); // Clear the session
            return RedirectToAction(nameof(Login));
        }
    }
}
