using DoctorFix.Data;
using DoctorFix.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Numerics;

public class DoctorFixController : Controller
{
    private readonly HospitalDbContext _context;
    public DoctorFixController(HospitalDbContext context)
    {
        _context = context;
    }

    // GET: Doctors
    public async Task<IActionResult> Index()
    {
        var doctors = await _context.Doctors.Include(d => d.DoctorId).ToListAsync();
        return View(doctors);
    }

    // GET: Doctors/Details/5
    public async Task<IActionResult> Details(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var doctor = await _context.Doctors
            .Include(d => d.Department)
            .FirstOrDefaultAsync(m => m.DoctorId == id);
        if (doctor == null)
        {
            return NotFound();
        }

        return View(doctor);
    }

    public IActionResult Create()
    {
        ViewBag.DepartmentID = new SelectList(_context.Departments, "DepartmentID", "DepartmentName");
        ViewBag.DoctorID = new SelectList(_context.Doctors, "DoctorID", "FullName");
        return View();
    }

    // POST: Doctors/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create([Bind("DoctorID,FullName,Position,Specialty,ImageUrl,DescriptionDoctor,Experience,Education,DepartmentID")] Doctor doctor)
    {
        if (ModelState.IsValid)
        {
            _context.Add(doctor);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        // Đảm bảo rằng ViewBag.DepartmentID được khởi tạo lại nếu ModelState không hợp lệ
        ViewBag.DepartmentID = new SelectList(_context.Departments, "DepartmentID", "DepartmentName", doctor.DepartmentID);
        ViewBag.DoctorID = new SelectList(_context.Doctors, "DoctorID", "FullName", doctor.DoctorId);
        return View(doctor);
    }
    // GET: Doctors/Edit/5
    public async Task<IActionResult> Edit(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var doctor = await _context.Doctors.FindAsync(id);
        if (doctor == null)
        {
            return NotFound();
        }
        ViewData["DepartmentID"] = new SelectList(_context.Departments, "DepartmentID", "DepartmentName", doctor.DepartmentID);
        return View(doctor);
    }

    // POST: Doctors/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, [Bind("DoctorID,FullName,Position,Specialty,ImageUrl,DescriptionDoctor,Experience,Education,DepartmentID")] Doctor doctor)
    {
        if (id != doctor.DoctorId)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            try
            {
                _context.Update(doctor);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DoctorExists(doctor.DoctorId))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return RedirectToAction(nameof(Index));
        }
        ViewData["DepartmentID"] = new SelectList(_context.Departments, "DepartmentID", "DepartmentName", doctor.DepartmentID);
        return View(doctor);
    }

    // GET: Doctors/Delete/5
    public async Task<IActionResult> Delete(int? id)
    {
        if (id == null)
        {
            return NotFound();
        }

        var doctor = await _context.Doctors
            .Include(d => d.Department)
            .FirstOrDefaultAsync(m => m.DoctorId == id);
        if (doctor == null)
        {
            return NotFound();
        }

        return View(doctor);
    }

    // POST: Doctors/Delete/5
    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        var doctor = await _context.Doctors.FindAsync(id);
        _context.Doctors.Remove(doctor);
        await _context.SaveChangesAsync();
        return RedirectToAction(nameof(Index));
    }

    private bool DoctorExists(int id)
    {
        return _context.Doctors.Any(e => e.DoctorId == id);
    }
}
