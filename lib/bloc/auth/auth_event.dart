part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Register extends AuthEvent {
  final UserModel user;
  final File file;
  const Register({required this.user, required this.file});

  @override
  List<Object> get props => [user];
}

class SignIn extends AuthEvent {
  final String email;
  final String password;
  const SignIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOut extends AuthEvent {}

class ToggleVisiblity extends AuthEvent {
  final bool isVisible;
  const ToggleVisiblity({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}

class CameraCapture extends AuthEvent {}

class GalleryImagePicker extends AuthEvent {}
