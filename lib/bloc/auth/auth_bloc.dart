import 'package:todo_app/exports.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(const AuthState()) {
    on<CheckUserStatus>(_checkUserStatus);
    on<Register>(_register);
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
    on<ToggleVisiblity>(_toggleVisibility);
    on<CameraCapture>(_cameraCapture);
    on<GalleryImagePicker>(_galleryPicker);
  }

  void _checkUserStatus(CheckUserStatus event, Emitter<AuthState> emit) {
    bool isLoggedIn = _authRepository.checkLoggedInStatus();
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  void _register(Register event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    String message = await _authRepository.signUpUser(user: event.user);

    await _authRepository
        .saveUserData(user: event.user, picFile: event.file)
        .then((value) {
      emit(state.copyWith(message: value, status: AuthStatus.success));
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(
            message: error.toString(), status: AuthStatus.failure));
      },
    );

    emit(state.copyWith(message: message, status: AuthStatus.success));
  }

  void _signIn(SignIn event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _authRepository
        .signInUser(email: event.email, password: event.password)
        .then((value) {
      emit(state.copyWith(message: value, status: AuthStatus.success));
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          message: error.toString(), status: AuthStatus.failure));
    });
  }

  void _signOut(SignOut event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _authRepository.signOutUser().then((value) {
      emit(state.copyWith(message: value, status: AuthStatus.success));
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          message: error.toString(), status: AuthStatus.failure));
    });
  }

  void _toggleVisibility(ToggleVisiblity event, Emitter<AuthState> emit) {
    emit(state.copyWith(isVisible: event.isVisible));
  }

  void _cameraCapture(CameraCapture event, Emitter<AuthState> emit) async {
    XFile? file = await cameraCapture(); // From Utils
    emit(state.copyWith(file: file));
  }

  void _galleryPicker(GalleryImagePicker event, Emitter<AuthState> emit) async {
    XFile? file = await galleryImagePicker(); // From Utils
    emit(state.copyWith(file: file));
  }
}
