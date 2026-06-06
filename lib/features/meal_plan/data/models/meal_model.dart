class MealModel {
  final String id;
  final String name;
  final String difficulty; // Dễ, Trung bình, Khó
  final int cookingTime; // Phút
  final bool isLocked; // Trạng thái khóa món khi xoay thực đơn

  MealModel({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.cookingTime,
    this.isLocked = false,
  });

  // Tạo bản sao mới khi thay đổi trạng thái (Ví dụ: bấm Khóa/Mở khóa)
  MealModel copyWith({bool? isLocked}) {
    return MealModel(
      id: id,
      name: name,
      difficulty: difficulty,
      cookingTime: cookingTime,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  // Chuyển đổi từ dữ liệu Supabase (Postgres) về Model
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as String,
      name: json['name'] as String,
      difficulty: json['difficulty'] as String? ?? 'Dễ',
      cookingTime: json['cooking_time'] as int? ?? 20,
      isLocked: json['is_locked'] as bool? ?? false,
    );
  }

  // Chuyển đổi sang JSON để HydratedBLoC lưu xuống máy offline
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
      'cooking_time': cookingTime,
      'is_locked': isLocked,
    };
  }
}
