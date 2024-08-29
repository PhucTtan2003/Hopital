using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Booklich.Controllers
{
    public class SummaryController : Controller
    {
        private readonly HospitalDbContext _context;

        public SummaryController(HospitalDbContext context)
        {
            _context = context;
        }

        public IActionResult Index(int timeSlotId)
        {
            try
            {
                var patientId = TempData["patient"] as int?;
                var specialty = TempData["Specialty"] as string;
                var doctorId = TempData["DoctorId"] as int?;
                var timeSlotsJson = TempData["TimeSlots"] as string;

                if (patientId == null || string.IsNullOrEmpty(specialty) || doctorId == null || string.IsNullOrEmpty(timeSlotsJson))
                {
                    // Redirect if missing required information
                    return RedirectToAction("BookAppointment", "Patient");
                }

                // Retrieve patient, doctor, and selected time slot from database
                var patient = _context.Patients.Find(patientId);
                var doctor = _context.Doctors.Find(doctorId);
                var specialtyEntity = _context.SelectSpecialties.FirstOrDefault(s => s.Specialty == specialty);
                var timeSlots = JsonConvert.DeserializeObject<List<TimeSlot>>(timeSlotsJson);
                var selectedTimeSlot = timeSlots?.FirstOrDefault(ts => ts.TimeSlotId == timeSlotId);

                if (patient == null || doctor == null || selectedTimeSlot == null)
                {
                    return RedirectToAction("Error", new { message = "Invalid information provided." });
                }

                // Create ViewModel to display in the view
                var summaryViewModel = new Summary
                {
                    Patient = patient,
                    Doctor = doctor,
                    Specialty = specialtyEntity,
                    TimeSlot = selectedTimeSlot,
                    Fee = 150000,
                    Notes = ""
                };

                TempData["summary"] = JsonConvert.SerializeObject(summaryViewModel,
                    new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });

                return View(summaryViewModel);
            }
            catch (Exception ex)
            {
                // Log the exception and redirect to error page
                return RedirectToAction("Error", new { message = "An error occurred while processing your request. Please try again later." });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Confirm(Summary summary)
        {
            try
            {
                var note = summary.Notes;
                var summaryJson = TempData["summary"] as string;
                summary = JsonConvert.DeserializeObject<Summary>(summaryJson);

                if (summary == null)
                {
                    return RedirectToAction("Error", new { message = "Unable to retrieve summary information." });
                }

                var appointment = new Appointment
                {
                    PatientId = summary.Patient.PatientId,
                    DoctorId = summary.Doctor.DoctorId,
                    TimeSlotId = summary.TimeSlot.TimeSlotId,
                    Fee = summary.Fee,
                    Notes = note
                };

                _context.Appointments.Add(appointment);
                _context.SaveChanges();

                TempData["AppointmentId"] = appointment.AppointmentId;

                // Redirect to the success page
                return RedirectToAction("Success");
            }
            catch (Exception ex)
            {
                // Log the exception and redirect to error page
                return RedirectToAction("Error", new { message = "An error occurred while confirming the appointment. Please try again later." });
            }
        }
        public IActionResult Success()
        {
            var appointmentId = TempData["AppointmentId"] as int?;
            if (appointmentId == null)
            {
                return RedirectToAction("Error", new { message = "Appointment not found." });
            }

            var appointments = _context.Appointments
                .Include(a => a.Patient)
                .Include(a => a.Doctor)
                .Include(a => a.TimeSlot)
                .Where(a => a.AppointmentId == appointmentId)
                .ToList();

            if (!appointments.Any())
            {
                return RedirectToAction("Error", new { message = "Appointment details not found." });
            }

            return View(appointments);
        }


    }
}
