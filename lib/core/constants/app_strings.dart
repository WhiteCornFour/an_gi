import 'package:an_gi/features/auth/presentation/constants/auth_strings.dart';
import 'package:an_gi/core/constants/meal_plan_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../localization/language_cubit.dart';

class AppStrings {
  static final Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      ...AuthStrings.localizedValues['vi']!,
      ...MealPlanStrings.localizedValues['vi']!,
      'select_language': 'Chọn Ngôn Ngữ', // Bổ sung key để fix lỗi ảnh 3
    },
    'en': {
      ...AuthStrings.localizedValues['en']!,
      ...MealPlanStrings.localizedValues['en']!,
      'select_language': 'Select Language', // Bổ sung key để fix lỗi ảnh 3
    },
  };

  // Nhận context trước, key sau theo đúng chuẩn điều phối UI
  static String get(BuildContext context, String key) {
    // FIX LỖI ẢNH 1: Đọc trực tiếp chuỗi String từ state của Cubit
    final String locale = context.watch<LanguageCubit>().state;
    return _localizedValues[locale]?[key] ?? key;
  }
}
