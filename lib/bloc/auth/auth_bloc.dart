import 'package:todo_app/exports.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(const AuthState()) {
    on<Register>(_register);
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
    on<ToggleVisiblity>(_toggleVisibility);
  }

  void _register(Register event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    String message = await _authRepository.signUpUser(
        email: event.email, password: event.password);

    emit(state.copyWith(message: message, status: AuthStatus.success));
  }

  void _signIn(SignIn event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    String message = await _authRepository.signInUser(
        email: event.email, password: event.password);

    emit(state.copyWith(message: message, status: AuthStatus.success));
  }

  void _signOut(SignOut event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    String message = await _authRepository.signOutUser();

    emit(state.copyWith(message: message, status: AuthStatus.success));
  }

  void _toggleVisibility(ToggleVisiblity event, Emitter<AuthState> emit) {
    emit(state.copyWith(isVisible: event.isVisible));
  }
}
