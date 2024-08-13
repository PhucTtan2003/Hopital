using Login.Data;
using Microsoft.AspNetCore.Mvc;

namespace Login.Controllers
{
    public class UserController : Controller
    {
        private readonly HospitalDbContext _context;
        public UserController()
        {
            _context = new HospitalDbContext();
        }

        public ActionResult Index()
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
                return RedirectToAction("Index", "Home");
            }

            ModelState.AddModelError("", "Invalid username or password");
            return View();
        }
    }
}
