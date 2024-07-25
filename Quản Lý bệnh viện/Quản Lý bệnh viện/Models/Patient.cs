namespace Quản_Lý_bệnh_viện.Models
{
    public class Patient
    {
        private ICollection<Appointment> appointments;
        private ICollection<MedicalRecord> medicalRecords;

        public int PatientID { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? Address { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }
        public ICollection<MedicalRecord> MedicalRecords { get => medicalRecords; set => medicalRecords = value; }
        public ICollection<Appointment> Appointments { get => Appointments1; set => Appointments1 = value; }
        public ICollection<Appointment> Appointments1 { get => appointments; set => appointments = value; }
    }
}
