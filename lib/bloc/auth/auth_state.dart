part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String email;
  final String password;
  final String message;
  final AuthStatus status;
  final bool isVisible;
  final XFile? file;
  const AuthState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.status = AuthStatus.initial,
    this.isVisible = false,
    this.file,
  });

  AuthState copyWith({
    String? email,
    String? password,
    String? message,
    AuthStatus? status,
    bool? isVisible,
    XFile? file,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      status: status ?? this.status,
      isVisible: isVisible ?? this.isVisible,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, message, status, isVisible, file];
}
