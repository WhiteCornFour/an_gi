import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../localization/language_cubit.dart';
import '../../features/auth/presentation/constants/auth_strings.dart';

class AppStrings {
  /// Bộ từ điển cốt lõi của hệ thống (Core Strings)
  static const Map<String, String> _coreVi = {
    'error_unknown': 'Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.',
    'warning_form_invalid': 'Vui lòng kiểm tra chính xác các thông tin màu đỏ!',
  };

  static const Map<String, String> _coreEn = {
    'error_unknown': 'An unknown error occurred. Please try again later.',
    'warning_form_invalid':
        'Please check the red information fields correctly!',
  };

  /// Bản đồ động kết hợp toàn bộ từ điển hệ thống và các tính năng cục bộ
  static Map<String, String> _getLocalizedMap(String languageCode) {
    // Trích xuất an toàn từ điển từ tính năng Auth, phòng hờ trường hợp null bằng Map trống {}
    final authData = AuthStrings.localizedValues[languageCode] ?? {};

    if (languageCode == 'en') {
      return {..._coreEn, ...authData};
    }

    // Mặc định luôn fallback về Tiếng Việt
    return {..._coreVi, ...authData};
  }

  /// Hàm gác cổng dịch thuật toàn diện - Sạch bóng lỗi Linting và Crash UI
  static String get(BuildContext context, String key) {
    try {
      // Đọc trực tiếp trạng thái ngôn ngữ hiện tại dạng String từ LanguageCubit
      final currentLanguage = context.read<LanguageCubit>().state;

      // Lấy map ngôn ngữ đã được gộp an toàn
      final currentMap = _getLocalizedMap(currentLanguage);

      if (currentMap.containsKey(key)) {
        return currentMap[key]!;
      }

      // Fallback 1: Nếu không tìm thấy ở ngôn ngữ hiện tại, quét tìm trong Map tiếng Việt
      final viMap = _getLocalizedMap('vi');
      if (viMap.containsKey(key)) {
        return viMap[key]!;
      }
    } catch (_) {
      // Phòng vệ từ xa nếu Cubit chưa kịp khởi tạo trong môi trường Test
      return key;
    }

    // Fallback cuối cùng: Trả về chính cái Key gốc
    return key;
  }
}
