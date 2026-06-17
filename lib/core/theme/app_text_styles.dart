import 'package:an_gi/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:an_gi/core/theme/app_colors.dart';
import 'package:an_gi/core/theme/app_sizes.dart';

class AppTextStyles {
  // 1. Tiêu đề lớn nhất màn hình (Ví dụ: "HÔM NAY ĂN GÌ?")
  static TextStyle header(BuildContext context) => TextStyle(
    fontSize: AppSizes.fontHeader(context), // Đã truyền context vào hàm size
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // 2. Tên món ăn trên các tấm Card lớn
  static TextStyle titleMeal(BuildContext context) => TextStyle(
    fontSize: AppSizes.fontTitle(context), // Đã truyền context vào hàm size
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // 3. Chữ trên các nút bấm lớn (Nút Xác nhận, Nút Xoay)
  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontSize: AppSizes.fontSubTitle(context),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // 4. Chữ hiển thị nguyên liệu, công thức (Dành cho dòng đọc nhiều)
  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: AppSizes.fontBody(context),
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4, // Tạo khoảng cách dòng thoáng đãng, dễ đọc
  );

  // 5. Chữ phụ, chú thích nhỏ
  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: AppSizes.fontCaption(context),
    color: AppColors.textSecondary,
  );

  static TextStyle heading1(BuildContext context) =>
      TextStyle(fontSize: context.scaleSp(28), fontWeight: FontWeight.bold);

  static TextStyle bodyMedium(BuildContext context) =>
      TextStyle(fontSize: context.scaleSp(16), fontWeight: FontWeight.normal);

  static TextStyle bodyBold(BuildContext context) =>
      TextStyle(fontSize: context.scaleSp(16), fontWeight: FontWeight.bold);
}
