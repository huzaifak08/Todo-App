import 'package:todo_app/exports.dart';

class TodoModel extends Equatable {
  final String? docId;
  final String? uid;
  final String title;
  final String description;
  final String createdAt;
  const TodoModel({
    this.docId,
    this.uid,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  TodoModel copyWith({
    ValueGetter<String?>? docId,
    ValueGetter<String?>? uid,
    String? title,
    String? description,
    String? createdAt,
  }) {
    return TodoModel(
      docId: docId != null ? docId() : this.docId,
      uid: uid != null ? uid() : this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'uid': uid,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      docId: map['docId'],
      uid: map['uid'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodoModel(docId: $docId, uid: $uid, title: $title, description: $description, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props {
    return [
      docId,
      uid,
      title,
      description,
      createdAt,
    ];
  }
}
