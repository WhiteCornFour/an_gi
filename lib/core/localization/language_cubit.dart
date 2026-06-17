import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<String> {
  // Mặc định ban đầu hệ thống chọn Tiếng Việt
  LanguageCubit() : super('vi');

  void changeLanguage(String languageCode) {
    emit(languageCode);
  }
}
