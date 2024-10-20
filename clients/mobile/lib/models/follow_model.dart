class FollowModel {
  final bool isFollower;
  final bool isFollowing;

  final int followerCount;
  final int followCount;

  FollowModel.named({
    required this.isFollower,
    required this.isFollowing,
    required this.followerCount,
    required this.followCount,
  });

  factory FollowModel.fromJSONAPI(Map<String, dynamic> object) {
    return FollowModel.named(
        isFollower: object["isFollower"],
        isFollowing: object["isFollowing"],
        followerCount: object["followerCount"],
        followCount: object["followCount"]
    );
  }
}