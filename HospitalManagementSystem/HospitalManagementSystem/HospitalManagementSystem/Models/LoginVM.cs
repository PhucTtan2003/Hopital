using System.ComponentModel.DataAnnotations;

namespace HospitalManagementSystem.Models
{
    public class LoginVM
    {
        [Required(ErrorMessage = "Username is required.")]
        [StringLength(50, ErrorMessage = "Username cannot exceed 50 characters.")]
        public string Username { get; set; } = null!;

        [Required(ErrorMessage = "Password is required.")]
        [DataType(DataType.Password)]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Password must be at least 6 characters long.")]
        public string PasswordAccount { get; set; } = null!;

        [Required(ErrorMessage = "Role is required.")]
        [RegularExpression("admin|khach", ErrorMessage = "Role must be either 'admin' or 'khach'.")]
        public string Roles { get; set; } = null!;

    }
}