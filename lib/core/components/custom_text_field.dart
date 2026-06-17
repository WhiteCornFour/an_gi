import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool
  enabled; // Thêm cờ trạng thái đóng/mở khóa khi hệ thống loading API
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    required this.prefixIcon,
    this.suffixIcon,
    this.enabled = true, // Mặc định luôn mở khóa để nhập liệu bình thường
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyBold(context).copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSizes.spaceS(context)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled, // Áp dụng trực tiếp cờ khóa tương tác hệ thống
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium(
              context,
            ).copyWith(color: AppColors.textHint),
            prefixIcon: Icon(
              prefixIcon,
              color: enabled ? AppColors.textSecondary : AppColors.textHint,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled
                ? Colors.white
                : const Color(0xFFF5F5F5), // Đổi nền xám nhẹ khi bị khóa
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSizes.spaceM(context),
              horizontal: AppSizes.spaceM(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM(context)),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM(context)),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM(context)),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM(context)),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM(context)),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
