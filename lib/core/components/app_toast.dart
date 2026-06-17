import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';
import '../theme/app_text_styles.dart';

enum ToastType { success, error, warning }

class AppToast {
  /// Hàm triệu hồi thông báo nổi lên trên màn hình mà không làm nghẽn mạch UI
  static void show(
    BuildContext context, {
    required String message,
    required ToastType type,
  }) {
    // 1. Lấy thông tin Overlay hiện tại của màn hình
    final overlayState = Overlay.of(context);

    // 2. Định nghĩa cấu hình màu sắc và icon tĩnh tương ứng với từng trạng thái
    Color backgroundColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFFE8F5E9); // Nền xanh lá nhạt cứng
        iconColor = const Color(0xFF2E7D32); // Icon xanh lá đậm
        iconData = Icons.check_circle_rounded;
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFFFEBEE); // Nền đỏ nhạt cứng
        iconColor = const Color(0xFFC62828); // Icon đỏ đậm
        iconData = Icons.error_rounded;
        break;
      case ToastType.warning:
        backgroundColor = const Color(0xFFFFF3E0); // Nền vàng cam nhạt cứng
        iconColor = const Color(0xFFEF6C00); // Icon vàng cam đậm
        iconData = Icons.warning_rounded;
        break;
    }

    // 3. Khởi tạo mảnh ghép Overlay Entry để thả nổi tự do trên cây Widget
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + AppSizes.spaceM(context),
        left: AppSizes.paddingL(context),
        right: AppSizes.paddingL(context),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM(context),
              vertical: AppSizes.spaceM(context),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusM(context)),
              border: Border.all(color: iconColor, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000), // Đổ bóng tĩnh nhẹ nhàng
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: iconColor,
                  size: AppSizes.spaceX(context),
                ),
                SizedBox(width: AppSizes.spaceM(context)),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: const Color(
                        0xFF212121,
                      ), // Chữ đen xám rõ ràng tương phản cao
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 4. Đưa thông báo lên màn hình
    overlayState.insert(overlayEntry);

    // 5. Tự động trục xuất thông báo sau 2.5 giây mượt mà
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
