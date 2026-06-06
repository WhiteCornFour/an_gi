import 'package:an_gi/features/meal_plan/data/models/meal_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

class MealPlanBloc extends HydratedBloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc() : super(MealPlanState()) {
    on<GenerateMealPlanEvent>(_onGenerateMealPlan);
    on<ToggleLockMealEvent>(_onToggleLockMeal);
    on<ShuffleMealsEvent>(_onShuffleMeals);
  }

  // 1. Logic khởi tạo thực đơn ban đầu
  void _onGenerateMealPlan(
    GenerateMealPlanEvent event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Mock data trước khi kết nối Supabase API để test logic "Xoay"
      final mockMeals = List.generate(
        event.days,
        (index) => MealModel(
          id: 'id_$index',
          name: 'Món ngon ngày ${index + 1}',
          difficulty: 'Dễ',
          cookingTime: 20,
        ),
      );
      emit(state.copyWith(meals: mockMeals, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // 2. Logic Khóa / Mở khóa món ăn
  void _onToggleLockMeal(
    ToggleLockMealEvent event,
    Emitter<MealPlanState> emit,
  ) {
    final updatedMeals = state.meals.map((meal) {
      if (meal.id == event.mealId) {
        return meal.copyWith(isLocked: !meal.isLocked); // Đảo trạng thái khóa
      }
      return meal;
    }).toList();

    emit(state.copyWith(meals: updatedMeals));
  }

  // 3. Logic Xoay món (Shuffle) - Chỉ đổi món nào CHƯA KHÓA
  void _onShuffleMeals(ShuffleMealsEvent event, Emitter<MealPlanState> emit) {
    final updatedMeals = state.meals.map((meal) {
      if (!meal.isLocked) {
        // Tạo tạm một món ngẫu nhiên mới để kiểm tra logic
        final randomId = DateTime.now().millisecondsSinceEpoch.toString();
        return MealModel(
          id: meal.id, // Giữ nguyên ID vị trí ngày đó
          name: 'Món mới đổi cực ngon ($randomId)',
          difficulty: meal.difficulty,
          cookingTime: meal.cookingTime,
          isLocked: false,
        );
      }
      return meal; // Món nào khóa thì giữ nguyên
    }).toList();

    emit(state.copyWith(meals: updatedMeals));
  }

  // ---- ĐOẠN CODE PHỤC VỤ OFFLINE (HYDRATED BLOC) ----

  @override
  MealPlanState? fromJson(Map<String, dynamic> json) {
    try {
      final mealsJson = json['meals'] as List<dynamic>;
      final meals = mealsJson
          .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return MealPlanState(meals: meals);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(MealPlanState state) {
    return {'meals': state.meals.map((e) => e.toJson()).toList()};
  }
}
