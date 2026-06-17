import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  // Lấy kích thước thực tế của thiết bị
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Tính toán tỷ lệ co giãn theo chiều ngang (Base on iPhone 13/14 width: 390)
  double scaleW(double width) => (screenWidth / 390) * width;

  // Tính toán tỷ lệ co giãn theo chiều dọc (Base on iPhone 13/14 height: 844)
  double scaleH(double height) => (screenHeight / 844) * height;

  // Tính toán kích thước chữ (Font size) bảo toàn tỷ lệ
  double scaleSp(double fontSize) => scaleW(fontSize);
}
