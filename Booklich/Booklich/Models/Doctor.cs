namespace Booklich.Models
{
    public class Doctor
    {
        public int DoctorID { get; set; }
        public string FullName { get; set; }
        public string Position { get; set; }
        public string Specialty { get; set; }
        public string ImageUrl { get; set; }
        public string DescriptionDoctor { get; set; }
        public string Experience { get; set; }
        public string Education { get; set; }
        public int DepartmentID { get; set; }

        public Department Department { get; set; }
    }
}
