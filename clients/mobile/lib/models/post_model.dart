class PostModel {
  final int postID;
  final int postUserID;
  final String postContent;
  final DateTime postCreatedAt;

  PostModel(
      {required this.postID,
      required this.postUserID,
      required this.postContent,
      required this.postCreatedAt});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postID: int.parse(json['post_id'], radix: 2),
      postUserID: int.parse(json['post_user_id'], radix: 2),
      postContent: json['post_content'],
      postCreatedAt: DateTime.parse(json['post_created_at']),
    );
  }
}
