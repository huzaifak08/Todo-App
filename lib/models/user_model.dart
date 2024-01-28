import 'package:todo_app/exports.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final int phone;
  final String email;
  final String password;
  final String profilePic;
  const UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.profilePic,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    int? phone,
    String? email,
    String? password,
    String? profilePic,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone']?.toInt() ?? 0,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, phone: $phone, email: $email, password: $password, profilePic: $profilePic)';
  }

  @override
  List<Object> get props {
    return [
      uid,
      name,
      phone,
      email,
      password,
      profilePic,
    ];
  }
}
