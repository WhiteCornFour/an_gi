import 'package:flutter/material.dart';

class AppColors {
  // 1. Màu chủ đạo (Primary): Sắc xanh ngọc/xanh lá tươi của rau củ tươi, tạo cảm giác an toàn, sạch sẽ
  static const Color primary = Color(
    0xFF2E7D32,
  ); // Xanh lá đậm chuẩn ISO, tương phản cực tốt với chữ trắng
  static const Color primaryLight = Color(
    0xFFE8F5E9,
  ); // Nền xanh nhạt dùng cho các thẻ Card món ăn

  // 2. Màu điểm nhấn (Accent): Màu cam ấm của ngọn lửa bếp và món kho, kích thích thèm ăn, dùng cho nút "XOAY MÓN"
  static const Color accent = Color(
    0xFFE65100,
  ); // Cam đậm quyến rũ, cực bắt mắt thu hút hành động

  // 3. Hệ chữ (Typography): Phải dùng màu gần như đen tuyệt đối cho người lớn tuổi dễ đọc
  static const Color textPrimary = Color(
    0xFF1A1A1A,
  ); // Chữ chính (Tên món, tiêu đề)
  static const Color textSecondary = Color(
    0xFF555555,
  ); // Chữ phụ (Định lượng, nguyên liệu)

  // 4. Màu nền và trạng thái
  static const Color background = Color(
    0xFFFAFAFA,
  ); // Trắng kem siêu dịu mắt khi đứng trong bếp tối
  static const Color border = Color(0xFFE0E0E0);
  static const Color error = Color(
    0xFFC62828,
  ); // Đỏ cảnh báo (khi hết tiền túi hoặc món trùng)
}
