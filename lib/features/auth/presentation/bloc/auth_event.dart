abstract class AuthEvent {
  const AuthEvent();
}

class RegisterSubmittedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterSubmittedEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginSubmittedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmittedEvent({required this.email, required this.password});
}
