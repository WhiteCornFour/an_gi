import 'package:an_gi/core/constants/auth_strings.dart';
import 'package:an_gi/core/constants/meal_plan_strings.dart';

class AppStrings {
  // Gộp tất cả các bản đồ ngôn ngữ từ các feature lại bằng toán tử Spread (...)
  static final Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      ...AuthStrings.localizedValues['vi']!,
      ...MealPlanStrings.localizedValues['vi']!,
    },
    'en': {
      ...AuthStrings.localizedValues['en']!,
      ...MealPlanStrings.localizedValues['en']!,
    },
  };

  // Hàm Get dùng chung toàn app giữ nguyên, không cần sửa đổi ở các màn hình UI
  static String get(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}
