
import 'package:an_gi/features/meal_plan/data/models/meal_model.dart';

class MealPlanState {
  final List<MealModel> meals;
  final bool isLoading;
  final String? errorMessage;

  MealPlanState({
    this.meals = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MealPlanState copyWith({
    List<MealModel>? meals,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MealPlanState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}