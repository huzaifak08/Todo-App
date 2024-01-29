part of 'user_bloc.dart';

class UserState extends Equatable {
  final UserModel? userModel;
  final UserDataStatus userDataStatus;
  const UserState({
    this.userModel,
    this.userDataStatus = UserDataStatus.initial,
  });

  UserState copyWith({UserModel? userModel, UserDataStatus? userDataStatus}) {
    return UserState(
      userModel: userModel ?? this.userModel,
      userDataStatus: userDataStatus ?? this.userDataStatus,
    );
  }

  @override
  List<Object?> get props => [userModel, userDataStatus];
}
