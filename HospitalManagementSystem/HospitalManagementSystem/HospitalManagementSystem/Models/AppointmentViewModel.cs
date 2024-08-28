namespace HospitalManagementSystem.Models
{
    public class AppointmentViewModel
    {
        public int AppointmentId { get; set; }
        public DateOnly Date { get; set; }
        public string DoctorName { get; set; }
        public string PatientName { get; set; }
        public string DepartmentName { get; set; }

        public string AppointmentDate { get; set; } 

        public string AppointmentTime { get; set; } 

        public string Notes { get; set; }
    }

}
