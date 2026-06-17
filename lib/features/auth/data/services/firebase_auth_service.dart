import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Xử lý logic đăng ký tài khoản mới bằng Email và Password thật
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Gọi Firebase Auth tạo tài khoản ngầm
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // 2. Cập nhật ngay họ và tên cho Hồ sơ User trên Firebase
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name.trim());
      }

      return userCredential;
    } on FirebaseAuthException {
      // Ném lỗi nguyên bản ra ngoài để BLoC bắt và phân dịch ngôn ngữ
      rethrow;
    } catch (e) {
      throw Exception('Unknown auth error occurred');
    }
  }
}
