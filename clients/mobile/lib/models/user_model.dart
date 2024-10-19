class UserModel {
  final String userCommonName;
  final String userName;
  final String userBiography;
  final DateTime userCreatedAt;

  UserModel.named({
    required this.userCommonName,
    required this.userName,
    required this.userBiography,
    required this.userCreatedAt
  });

  factory UserModel.fromJSONAPI(Map<String, dynamic> object) {
    return UserModel.named(
        userCommonName: object["userCommonName"],
        userName: object["userName"],
        userBiography: object["userBiography"],
        userCreatedAt: object["userCreatedAt"]
    );
  }
}
