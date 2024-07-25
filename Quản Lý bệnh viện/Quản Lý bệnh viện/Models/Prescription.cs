namespace Quản_Lý_bệnh_viện.Models
{
    public class Prescription
    {
        public int PrescriptionID { get; set; }
        public int PatientID { get; set; }
        public int DoctorID { get; set; }
        public int MedicationID { get; set; }
        public DateTime Date { get; set; }
        public string Dosage { get; set; }
        public string Instructions { get; set; }

        // Navigation properties
        public Patient Patient { get; set; }
        public Doctor Doctor { get; set; }
        public Medication Medication { get; set; }
    }
}
