abstract class MealPlanEvent {}

// Sự kiện khởi tạo/gợi ý thực đơn mới (Ví dụ: chọn gói 3 ngày hoặc 7 ngày)
class GenerateMealPlanEvent extends MealPlanEvent {
  final int days;
  GenerateMealPlanEvent(this.days);
}

// Sự kiện bấm nút "Xoay món" (Chỉ đổi những món chưa bị khóa)
class ShuffleMealsEvent extends MealPlanEvent {}

// Sự kiện bấm nút "Khóa/Mở khóa" một món cụ thể
class ToggleLockMealEvent extends MealPlanEvent {
  final String mealId;
  ToggleLockMealEvent(this.mealId);
}