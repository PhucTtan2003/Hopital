namespace Quản_Lý_bệnh_viện.Models
{
    public class Billing
    {
        public int BillingID { get; set; }
        public int PatientID { get; set; }
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; }

        // Navigation properties
        public Patient Patient { get; set; }
    }
}
