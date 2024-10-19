class UserModel {
  final String userCommonName;
  final String username;
  final String? userBiography;
  final String? userProfilePicture;
  final String? userBannerPicture;
  final DateTime userCreatedAt;

  UserModel.named({
    required this.userCommonName,
    required this.username,
    this.userBiography,
    this.userProfilePicture,
    this.userBannerPicture,
    required this.userCreatedAt
  });

  factory UserModel.fromJSONAPI(Map<String, dynamic> object) {
    print(object);

    return UserModel.named(
        userCommonName: object["userCommonName"],
        username: object["username"],
        userBiography: object["userBiography"],
        userProfilePicture: object["userProfilePicture"],
        userBannerPicture: object["userBannerPicture"],
        userCreatedAt: DateTime.parse(object["userCreatedAt"])
    );
  }
}
