namespace Booklich.Models
{
    public class Appointment
    {
        public int AppointmentID { get; set; }
        public int PatientID { get; set; }
        public DateTime AppointmentDate { get; set; }
        public string Reason { get; set; }

        public Patient Patient { get; set; }
    }
}
