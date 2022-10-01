class PostModel {
  final String title;
  final int id;
  final String body;
  final int userId;

  PostModel({
    required this.title,
    required this.id,
    required this.body,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        title: json["title"],
        body: json["body"],
        id: json["id"],
        userId: json["userId"],
      );
}
