using Booklich.Data;

namespace Booklich.Models
{
    public class Patient
    {
        public int PatientID { get; set; }
        public int AccountID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string Gender { get; set; }
        public string AddressPatients { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }

        public Account Account { get; set; }
        public ICollection<Appointment> Appointments { get; set; }
    }
}
