class UserModel {
  final int userID;
  final String userCommonName;
  final String userName;
  final String userPassword;
  final String? userBiography;
  final DateTime userCreatedAt;

  UserModel(
      {required this.userID,
      required this.userCommonName,
      required this.userName,
      required this.userPassword,
      required this.userBiography,
      required this.userCreatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userID: int.parse(json['user_id'], radix: 2),
      userCommonName: json['user_common_name'],
      userName: json['user_name'],
      userPassword: json['user_password'],
      userBiography: json['user_biography'],
      userCreatedAt: DateTime.parse(json['user_created_at']),
    );
  }
}
