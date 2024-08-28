using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HospitalManagementSystem.Models
{
    public class LoginVM
    {
        [Required(ErrorMessage = "Username is required")]
        public string? Username { get; set; }

        [Required(ErrorMessage = "Password is required")]
        public string? PasswordAccount { get; set; }

        [Required(ErrorMessage = "Role is required")]
        public string? Role { get; set; }

        public List<string> Roles { get; set; } = new List<string> { "Admin", "Khach" }; // Hoặc lấy từ database
    }
}
