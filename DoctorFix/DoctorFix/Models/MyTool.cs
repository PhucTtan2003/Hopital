namespace DoctorFix.Models
{
    public class MyTool
    {
        public static string UploadImageToFolder(IFormFile myfile, string folder)
        {
            try
            {
                // Tạo đường dẫn thư mục nếu chưa tồn tại
                var folderPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Images", folder);
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // Tạo tên tệp duy nhất để tránh ghi đè tệp có cùng tên
                var uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(myfile.FileName);
                var filePath = Path.Combine(folderPath, uniqueFileName);

                // Lưu tệp vào đường dẫn đã chỉ định
                using (var newFile = new FileStream(filePath, FileMode.Create))
                {
                    myfile.CopyTo(newFile);
                }

                // Trả về đường dẫn tương đối để lưu vào cơ sở dữ liệu
                return Path.Combine("/Images", folder, uniqueFileName).Replace("\\", "/");
            }
            catch (Exception ex)
            {
                // Xử lý lỗi nếu có
                return string.Empty;
            }
        }
    }
}
