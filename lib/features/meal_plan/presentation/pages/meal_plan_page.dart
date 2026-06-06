import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/meal_plan_bloc.dart';
import '../bloc/meal_plan_event.dart';
import '../bloc/meal_plan_state.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Khởi tạo BLoC và tự động kích hoạt gợi ý thực đơn 3 ngày làm mặc định
      create: (context) => MealPlanBloc()..add(GenerateMealPlanEvent(3)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thực Đơn Thông Minh',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          elevation: 2,
        ),
        body: const MealPlanView(),
        // Nút "Xoay Món" siêu to khổng lồ nằm ở góc dưới bên phải, cực kỳ dễ bấm bằng một tay
        floatingActionButton: const ShuffleFloatingButton(),
      ),
    );
  }
}

class MealPlanView extends StatelessWidget {
  const MealPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (state.errorMessage != null) {
          return Center(
            child: Text(
              'Đã có lỗi xảy ra: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (state.meals.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có thực đơn nào được tạo.\nHãy chọn số ngày bên dưới để bắt đầu!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            // 1. Khu vực chọn nhanh số ngày lên kế hoạch (1 ngày, 3 ngày, 7 ngày)
            const PlanDurationSelector(),

            // 2. Danh sách các món ăn trong kế hoạch tuần
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: state.meals.length,
                itemBuilder: (context, index) {
                  final meal = state.meals[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // Đổi màu nền nhẹ nếu món ăn đó đang bị KHÓA
                    color: meal.isLocked ? Colors.green.shade50 : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Biểu tượng món ăn đại diện (Có thể thay bằng ảnh từ Supabase Storage sau)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.green,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Thông tin món ăn
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày ${index + 1}: ${meal.name}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${meal.cookingTime} phút',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        meal.difficulty,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Nút Bấm Khóa / Mở Khóa món ăn
                          IconButton(
                            iconSize: 28,
                            icon: Icon(
                              meal.isLocked ? Icons.lock : Icons.lock_open,
                              color: meal.isLocked
                                  ? Colors.green.shade700
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              context.read<MealPlanBloc>().add(
                                ToggleLockMealEvent(meal.id),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget chọn thời gian: 1 ngày, 3 ngày hoặc 1 tuần
class PlanDurationSelector extends StatelessWidget {
  const PlanDurationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(context, title: '1 Ngày', days: 1),
          _buildButton(context, title: '3 Ngày', days: 3),
          _buildButton(context, title: '1 Tuần', days: 7),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required int days,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        context.read<MealPlanBloc>().add(GenerateMealPlanEvent(days));
      },
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

// Widget nút Xoay Món nổi trên giao diện
class ShuffleFloatingButton extends StatelessWidget {
  const ShuffleFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.read<MealPlanBloc>().add(ShuffleMealsEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔄 Đã xoay đổi các món chưa khóa!'),
            duration: Duration(milliseconds: 800),
          ),
        );
      },
      label: const Text(
        'XOAY MÓN',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      icon: const Icon(Icons.shuffle),
      backgroundColor: Colors.amber.shade700,
      foregroundColor: Colors.white,
    );
  }
}
