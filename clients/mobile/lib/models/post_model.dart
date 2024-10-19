class PostModel {
  final String postId;
  final String? postParentId;
  final String? postContent;
  final String? postMedia;
  final DateTime postCreatedAt;

  final String userCommonName;
  final String username;
  final int likeCount;
  final int replyCount;
  final bool hasLiked;

  PostModel.named({
    required this.postId,
    this.postParentId,
    this.postContent,
    this.postMedia,
    required this.postCreatedAt,

    required this.userCommonName,
    required this.username,
    required this.likeCount,
    required this.replyCount,
    required this.hasLiked
  });

  factory PostModel.fromJSONAPI(Map<String, dynamic> object) {
    return PostModel.named(
        postId: object["postId"],
        postParentId: object["postParentId"],
        postContent: object["postContent"],
        postMedia: object["postMedia"],
        postCreatedAt: object["postCreatedAt"],

        userCommonName: object["userCommonName"],
        username: object["username"],
        likeCount: object["likeCount"],
        replyCount: object["replyCount"],
        hasLiked: object["hasLiked"]
    );
  }
}
