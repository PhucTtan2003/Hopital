using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Quản_Lý_bệnh_viện.Data;
using Quản_Lý_bệnh_viện.Models;
using System.Threading.Tasks;

public class PatientsController : Controller
{
    private readonly ApplicationDbContext _context;

    public PatientsController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: Patients
    public async Task<IActionResult> Index()
    {
        try
        {
            var patients = await _context.Patients.ToListAsync();
            return View(patients);
        }
        catch (Exception ex)
        {
            // Log the exception (not implemented here)
            return View("Error"); // Consider creating an Error view
        }
    }

    // GET: Patients/Create
    public IActionResult Create()
    {
        return View();
    }

    // POST: Patients/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("FirstName,LastName,DateOfBirth,Gender,Address,Phone,Email")] Patient patient)
    {
        if (ModelState.IsValid)
        {
            try
            {
                _context.Add(patient);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                // Log the exception (not implemented here)
                ModelState.AddModelError("", "Unable to save changes. Try again, and if the problem persists see your system administrator.");
            }
        }
        return View(patient);
    }
}
