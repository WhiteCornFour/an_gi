import 'package:hydrated_bloc/hydrated_bloc.dart';

// 1. Định nghĩa trạng thái cấu hình hệ thống
class AppConfigState {
  final bool isLanguageSelected;
  final bool isOnboardingCompleted;

  AppConfigState({
    this.isLanguageSelected = false,
    this.isOnboardingCompleted = false,
  });

  AppConfigState copyWith({
    bool? isLanguageSelected,
    bool? isOnboardingCompleted,
  }) {
    return AppConfigState(
      isLanguageSelected: isLanguageSelected ?? this.isLanguageSelected,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }

  // Chuyển đổi sang JSON để HydratedBLoC tự lưu xuống bộ nhớ máy
  Map<String, dynamic> toMap() {
    return {
      'isLanguageSelected': isLanguageSelected,
      'isOnboardingCompleted': isOnboardingCompleted,
    };
  }

  // Khôi phục lại trạng thái cũ khi người dùng mở lại app
  factory AppConfigState.fromMap(Map<String, dynamic> map) {
    return AppConfigState(
      isLanguageSelected: map['isLanguageSelected'] ?? false,
      isOnboardingCompleted: map['isOnboardingCompleted'] ?? false,
    );
  }
}

// 2. Bộ não điều khiển việc ghi nhận trạng thái chạy lần đầu
class AppConfigCubit extends HydratedCubit<AppConfigState> {
  AppConfigCubit() : super(AppConfigState());

  void setLanguageSelected() {
    emit(state.copyWith(isLanguageSelected: true));
  }

  void setOnboardingCompleted() {
    emit(state.copyWith(isOnboardingCompleted: true));
  }

  @override
  AppConfigState? fromJson(Map<String, dynamic> json) =>
      AppConfigState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(AppConfigState state) => state.toMap();
}
