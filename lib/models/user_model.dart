import 'package:todo_app/exports.dart';

class UserModel extends Equatable {
  final String name;
  final int phone;
  final String email;
  final String password;
  const UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  UserModel copyWith({
    String? name,
    int? phone,
    String? email,
    String? password,
  }) {
    return UserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      phone: map['phone']?.toInt() ?? 0,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, phone: $phone, email: $email, password: $password)';
  }

  @override
  List<Object> get props => [name, phone, email, password];
}
