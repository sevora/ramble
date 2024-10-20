class PostModel {
  final String postId;
  final String? postParentId;
  final String postContent;
  final String? postMedia;
  final DateTime postCreatedAt;

  final String userCommonName;
  final String username;
  final String? userProfilePicture;
  final int likeCount;
  final int replyCount;
  final bool hasLiked;

  PostModel.named({
    required this.postId,
    this.postParentId,
    required this.postContent,
    this.postMedia,
    required this.postCreatedAt,

    required this.userCommonName,
    required this.username,
    this.userProfilePicture,
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
        postCreatedAt: DateTime.parse(object["postCreatedAt"]),

        userCommonName: object["userCommonName"],
        username: object["username"],
        userProfilePicture: object["userProfilePicture"],
        likeCount: object["likeCount"],
        replyCount: object["replyCount"],
        hasLiked: object["hasLiked"]
    );
  }
}
