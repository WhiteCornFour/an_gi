// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Màu chủ đạo kích thích vị giác (Cam ấm / Xanh lá tươi)
  static const Color primary = Color(0xFFE65100);
  static const Color secondary = Color(0xFF2E7D32);
  static const Color background = Color(0xFFF9F9F9);

  // Chữ & Văn bản độ tương phản cao
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);

  // --- GIẢI PHÁP THAY THẾ WITHOopacity ---
  // Thay vì AppColors.primary.withOpacity(0.1), ta dùng mã Hex mã hóa sẵn 10% Alpha (Đầu là 1A)
  static const Color primaryOpacity10 = Color(0x1AE65100);

  // Thay vì AppColors.textSecondary.withOpacity(0.2) cho Border, ta dùng mã Hex 20% Alpha (Đầu là 33)
  static const Color borderLight = Color(0x33757575);

  // Thay vì AppColors.textSecondary.withOpacity(0.6) cho HintText, ta dùng mã Hex 60% Alpha (Đầu là 99)
  static const Color textHint = Color(0x99757575);
}
