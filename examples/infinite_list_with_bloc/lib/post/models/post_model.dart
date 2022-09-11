import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int id;
  final String title;
  final String body;
  final int userId;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        userId: json["userId"],
      );

  static List<PostModel> listFromJson(List<dynamic> json) => json
      .map(
        (dynamic postJson) =>
            PostModel.fromJson(postJson as Map<String, dynamic>),
      )
      .toList();

  @override
  List<Object?> get props => [id, title, body, userId];
}
