import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/firebase_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService _authService;

  AuthBloc({required FirebaseAuthService authService})
    : _authService = authService,
      super(AuthInitialState()) {
    on<RegisterSubmittedEvent>(_onRegisterSubmitted);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final userCredential = await _authService.registerWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (userCredential.user != null) {
        emit(AuthRegisterSuccessState(user: userCredential.user!));
      } else {
        emit(const AuthFailureState(errorMessageKey: 'error_unknown'));
      }
    } on FirebaseAuthException catch (e) {
      // Ánh xạ mã lỗi đặc trưng từ Firebase Auth sang mã dịch thuật localization của hệ thống
      String errorKey = 'error_unknown';
      if (e.code == 'email-already-in-use') {
        errorKey = 'error_email_already_in_use';
      } else if (e.code == 'invalid-email') {
        errorKey = 'error_invalid_email';
      } else if (e.code == 'weak-password') {
        errorKey = 'error_weak_password';
      }
      emit(AuthFailureState(errorMessageKey: errorKey));
    } catch (_) {
      emit(const AuthFailureState(errorMessageKey: 'error_unknown'));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        emit(AuthLoginSuccessState(user: userCredential.user!));
      } else {
        emit(const AuthFailureState(errorMessageKey: 'error_unknown'));
      }
    } on FirebaseAuthException catch (e) {
      // Ánh xạ các mã lỗi xác thực đặc trưng từ hệ sinh thái Firebase Auth[cite: 8]
      String errorKey = 'error_unknown';

      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        // Có thể dùng chung một key báo sai thông tin tài khoản hoặc bổ sung vào auth_strings nếu cần
        errorKey = 'error_invalid_credential';
      } else if (e.code == 'invalid-email') {
        errorKey = 'error_invalid_email';
      } else if (e.code == 'user-disabled') {
        errorKey = 'error_user_disabled';
      } else if (e.code == 'too-many-requests') {
        errorKey = 'error_too_many_requests';
      }

      emit(AuthFailureState(errorMessageKey: errorKey));
    } catch (_) {
      emit(const AuthFailureState(errorMessageKey: 'error_unknown'));
    }
  }
}
