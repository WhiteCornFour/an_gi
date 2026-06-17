import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Gọi lệnh xác thực tài khoản từ thư viện Firebase SDK gốc
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      // Rethrow để AuthBloc có thể bắt chính xác mã code lỗi (e.g. 'wrong-password')
      rethrow;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

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

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }
}
