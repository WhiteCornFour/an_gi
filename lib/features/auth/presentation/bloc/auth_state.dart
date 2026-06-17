import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthRegisterSuccessState extends AuthState {
  final User user;
  const AuthRegisterSuccessState({required this.user});
}

class AuthFailureState extends AuthState {
  final String errorMessageKey;
  const AuthFailureState({required this.errorMessageKey});
}

class AuthLoginSuccessState extends AuthState {
  final User user;
  const AuthLoginSuccessState({required this.user});
}

class AuthForgotPasswordSuccessState extends AuthState {
  const AuthForgotPasswordSuccessState();
}
