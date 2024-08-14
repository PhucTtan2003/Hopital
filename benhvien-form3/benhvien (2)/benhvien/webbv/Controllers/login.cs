using Microsoft.AspNetCore.Mvc;

namespace webbv.Controllers
{
    public class login : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        //liên kết với trang login
        public IActionResult Login()
        {
            return View();
        }
    }
}
