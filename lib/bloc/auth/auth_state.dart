part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoggedIn;
  final String email;
  final String password;
  final String message;
  final AuthStatus status;
  final bool isVisible;
  final XFile? file;
  final bool isEmailSend;
  const AuthState({
    this.isLoggedIn = false,
    this.email = '',
    this.password = '',
    this.message = '',
    this.status = AuthStatus.initial,
    this.isVisible = false,
    this.file,
    this.isEmailSend = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? email,
    String? password,
    String? message,
    AuthStatus? status,
    bool? isVisible,
    XFile? file,
    bool? isEmailSend,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      status: status ?? this.status,
      isVisible: isVisible ?? this.isVisible,
      file: file ?? this.file,
      isEmailSend: isEmailSend ?? this.isEmailSend,
    );
  }

  @override
  List<Object?> get props => [
        isLoggedIn,
        email,
        password,
        message,
        status,
        isVisible,
        file,
        isEmailSend
      ];
}
