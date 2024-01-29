import 'package:todo_app/exports.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository = UserRepository();
  UserBloc() : super(const UserState()) {
    on<FetchUserData>(_fetchUserData);
  }

  void _fetchUserData(FetchUserData event, Emitter<UserState> emit) async {
    emit(state.copyWith(userDataStatus: UserDataStatus.loading));
    UserModel user = await _userRepository.getUserData();
    emit(state.copyWith(
        userModel: user, userDataStatus: UserDataStatus.success));
  }
}
