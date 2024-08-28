using Microsoft.AspNetCore.Mvc;
using HospitalManagementSystem.Data;
using HospitalManagementSystem.Models;
using System.Linq;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http;

namespace HospitalManagementSystem.Controllers
{
    public class MedicationController : Controller
    {
        private readonly HospitalDbContext _context;

        public MedicationController(HospitalDbContext context)
        {
            _context = context;
        }

        public IActionResult Pharmacity(string searchTerm)
        {
            var medications = _context.Medications.AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                medications = medications.Where(m => m.MedicationName.Contains(searchTerm) ||
                                                     m.DescriptionMedications.Contains(searchTerm));
            }

            var viewModel = new MedicationSearchViewModel
            {
                SearchTerm = searchTerm,
                Medications = medications.ToList()
            };

            return View(viewModel);
        }

        // Xử lý khi người dùng nhấn "Mua ngay"
        public IActionResult Checkout(int medicationId)
        {
            var medication = _context.Medications.FirstOrDefault(m => m.MedicationId == medicationId);

            if (medication == null)
            {
                return NotFound();
            }

            var cartItem = new CartItem
            {
                MedicationId = medication.MedicationId,
                MedicationName = medication.MedicationName,
                MedicationImage = medication.MedicationImage,
                Price = decimal.Parse(medication.FeeMedication),
                Quantity = 1 // Mặc định số lượng là 1, người dùng có thể thay đổi trên trang thanh toán
            };

            return View(cartItem);
        }

        // Action xử lý khi người dùng nhấn "Thêm vào giỏ hàng"
        [HttpPost]
        public IActionResult AddToCart(int medicationId)
        {
            // Lấy thông tin thuốc từ cơ sở dữ liệu
            var medication = _context.Medications.FirstOrDefault(m => m.MedicationId == medicationId);

            if (medication == null)
            {
                return NotFound();
            }

            // Lấy giỏ hàng từ session
            var cart = HttpContext.Session.GetObjectFromJson<List<CartItem>>("Cart") ?? new List<CartItem>();

            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            var cartItem = cart.FirstOrDefault(c => c.MedicationId == medicationId);

            if (cartItem != null)
            {
                // Nếu đã có trong giỏ hàng thì tăng số lượng lên
                cartItem.Quantity++;
            }
            else
            {
                // Nếu chưa có thì thêm sản phẩm vào giỏ hàng
                cart.Add(new CartItem
                {
                    MedicationId = medication.MedicationId,
                    MedicationName = medication.MedicationName,
                    MedicationImage = medication.MedicationImage,
                    Price = decimal.Parse(medication.FeeMedication),
                    Quantity = 1
                });
            }

            // Lưu giỏ hàng vào session
            HttpContext.Session.SetObjectAsJson("Cart", cart);

            // Trả về số lượng sản phẩm hiện tại trong giỏ hàng
            return Json(new { cartCount = cart.Sum(c => c.Quantity) });
        }

        // Xử lý thanh toán
        [HttpPost]
        public IActionResult ProcessPayment(CartItem cartItem)
        {
            // Xử lý thanh toán ở đây, ví dụ: lưu đơn hàng, trừ hàng tồn kho, v.v.
            // Sau đó chuyển hướng tới trang cảm ơn hoặc xác nhận đơn hàng

            return RedirectToAction("ThankYou");
        }

        public IActionResult ThankYou()
        {
            return View();

        }
        public IActionResult ViewCart()
        {
            // Lấy giỏ hàng từ session
            var cart = HttpContext.Session.GetObjectFromJson<List<CartItem>>("Cart") ?? new List<CartItem>();
            // Tính tổng tiền
            decimal totalAmount = cart.Sum(item => item.Total);

            // Truyền tổng tiền vào ViewBag
            ViewBag.TotalAmount = totalAmount;

            // Truyền giỏ hàng đến view
            return View(cart);
        }
        public IActionResult RemoveFromCart(int medicationId)
        {
            // Lấy giỏ hàng từ session
            var cart = HttpContext.Session.GetObjectFromJson<List<CartItem>>("Cart") ?? new List<CartItem>();

            // Tìm sản phẩm cần xóa
            var itemToRemove = cart.FirstOrDefault(c => c.MedicationId == medicationId);
            if (itemToRemove != null)
            {
                cart.Remove(itemToRemove);
            }

            // Lưu lại giỏ hàng vào session sau khi xóa
            HttpContext.Session.SetObjectAsJson("Cart", cart);

            // Tính toán lại tổng số tiền và cập nhật số lượng sản phẩm
            ViewBag.TotalAmount = cart.Sum(item => item.Total);

            // Chuyển hướng về lại trang giỏ hàng
            return RedirectToAction("ViewCart");
        }

    }
}
