import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ramble_mobile/models/follow_model.dart';
import 'package:ramble_mobile/models/post_model.dart';
import '../environment.dart';
import '../models/user_model.dart';

class UserController {
  UserController();

  final Map<String, String> _headers = {
    'content-type': 'application/json',
    'response-type': 'application/json'
  };

  UserModel? _user;

  UserModel get user {
    return _user ??
        UserModel.named(
            userCommonName: "Unknown",
            username: "unknown",
            userCreatedAt: DateTime.now()
        );
  }

  bool get loggedIn {
    return _user != null;
  }

  Future<UserModel> _getActiveUser() async {
    var uri = Uri.http(Environment.serverURL, "/account/view");
    var response = await http.post(uri, headers: _headers);
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  Future<UserModel> getUser({ required String username }) async {
    var uri = Uri.http(Environment.serverURL, "/account/view");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username
    }));
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  Future<void> login({required String usernameOrEmail, required String password}) async {
    var uri = Uri.http(Environment.serverURL, "/account/login");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "usernameOrEmail": usernameOrEmail,
      "password": password
    }));
    print(response.body);

    String? cookie = response.headers["set-cookie"];
    if (cookie != null) {
      int index = cookie.indexOf(";");
      _headers['cookie'] = (index == -1) ? cookie : cookie.substring(0, index);
      _user = await _getActiveUser();
    }
  }

  Future<void> logout() async {
    _headers.remove("cookie");
    _user = null;

    var uri = Uri.http(Environment.serverURL, "/account/logout");
    await http.post(uri, headers: _headers);
  }

  Future<UserModel> view({ String? username }) async {
    var uri = Uri.http(Environment.serverURL, "/account/view");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username ?? _user?.username,
    }));
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  Future<void> signUp({ required String username, required String email, required String password }) async {
    var uri = Uri.http(Environment.serverURL, "/account/signup");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username,
      "email": email,
      "password": password
    }));

    if (response.statusCode == 200) {
      await login(usernameOrEmail: username, password: password);
      _user = await _getActiveUser();
    }
  }

  Future<bool> updateAccount({ String? userCommonName, String? biography, File? profilePicture, File? bannerPicture }) async {
    var uri = Uri.http(Environment.serverURL, "/account/update");
    var request = http.MultipartRequest("post", uri);
    request.headers.addAll(_headers);

    if (userCommonName != null) {
      request.fields["userCommonName"] = userCommonName;
    }

    if (biography != null) {
      request.fields["biography"] = biography;
    }

    if (profilePicture != null) {
      request.files.add(
          await http.MultipartFile.fromPath("profile_picture", profilePicture.path)
      );
    }

    if (bannerPicture != null) {
      request.files.add(
          await http.MultipartFile.fromPath("banner_picture", bannerPicture.path)
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      _user = await _getActiveUser();
    }

    return response.statusCode == 200;
  }

  Future<void> deleteAccount() async {
    var uri = Uri.http(Environment.serverURL, "/account/delete");
    var response = await http.post(uri, headers: _headers);
    if (response.statusCode == 200) {
      _user = null;
    }
  }

  Future<List<String>> _listPosts({ int page=0, String? username, String? parentId, String? category }) async {
    var uri = Uri.http(Environment.serverURL, "/post/list");
    Map<String, dynamic> unencodedBody = { "page": page };

    if (username != null) {
      unencodedBody["username"] = username;
    }

    if (parentId != null) {
      unencodedBody["parentId"] = parentId;
    }

    if (category != null) {
      unencodedBody["category"] = category;
    }

    var response = await http.post(uri, headers: _headers, body: jsonEncode(unencodedBody));
    return List<String>.from(jsonDecode(response.body)["posts"]);
  }

  Future<PostModel> viewPost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/view");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({ "postId": postId }));
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return PostModel.fromJSONAPI(body);
  }

  Future<List<PostModel>> getPosts({ int page=0, String? username, String? parentId, String? category }) async {
    var postIds = await _listPosts(page: page, username: username, parentId: parentId, category: category);
    List<PostModel> posts = [];

    for (var postId in postIds) {
      posts.add(await viewPost(postId: postId));
    }

    return posts;
  }

  Future<bool> createPost({ required String content, String? parentId, File? image }) async {
    var uri = Uri.http(Environment.serverURL, "/post/new");

    var request = http.MultipartRequest("post", uri);
    request.headers.addAll(_headers);
    request.fields["content"] = content;

    if (parentId != null) {
      request.fields["parentId"] = parentId;
    }

    if (image != null) {
      request.files.add(
          await http.MultipartFile.fromPath("image", image.path)
      );
    }

    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> likePost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/like");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "postId": postId
    }));
    return response.statusCode == 200;
  }

  Future<bool> dislikePost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/dislike");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "postId": postId
    }));
    return response.statusCode == 200;
  }

  Future<bool> deletePost({ required String postId }) async {
    var uri = Uri.http(Environment.serverURL, "/post/delete");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "postId": postId
    }));
    return response.statusCode == 200;
  }

  Future<List<PostModel>> searchPosts({ required String content, int page=0 }) async {
    List<PostModel> posts = [];
    var uri = Uri.http(Environment.serverURL, "/search/post");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "content": content,
      "page": page
    }));

    var postIds = List<String>.from(jsonDecode(response.body)["posts"]);
    for (var postId in postIds) {
      posts.add(await viewPost(postId: postId));
    }
    return posts;
  }

  Future<List<UserModel>> searchAccounts({ required String username, int page=0 }) async {
    List<UserModel> users = [];
    var uri = Uri.http(Environment.serverURL, "/search/account");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username,
      "page": page
    }));

    var usernames = List<String>.from(jsonDecode(response.body)["users"]);
    for (var username in usernames) {
      users.add(await getUser(username: username));
    }
    return users;
  }

  Future<FollowModel> getFollowContextStatistics({ required String username }) async {
    var askUri = Uri.http(Environment.serverURL, "/follower/ask");
    var askResponse = await http.post(askUri, headers: _headers, body: jsonEncode({
      "username": username,
    }));
    var askBody = jsonDecode(askResponse.body) as Map<String, dynamic>;

    var countUri = Uri.http(Environment.serverURL, "/follower/count");
    var countResponse = await http.post(countUri, headers: _headers, body: jsonEncode({
      "username": username,
    }));
    var countBody = jsonDecode(countResponse.body) as Map<String, dynamic>;
    askBody.addAll(countBody);
    return FollowModel.fromJSONAPI(askBody);
  }

  Future<bool> followAccount({ required String username }) async {
    var uri = Uri.http(Environment.serverURL, "/follower/follow");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username
    }));
    return response.statusCode == 200;
  }

  Future<bool> unfollowAccount({ required String username }) async {
    var uri = Uri.http(Environment.serverURL, "/follower/unfollow");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username
    }));
    return response.statusCode == 200;
  }

  Future<List<UserModel>> getFollowAccounts({ int page=0, required String username, required String category  }) async {
    List<UserModel> users = [];
    var uri = Uri.http(Environment.serverURL, "/follower/list");
    var response = await http.post(uri, headers: _headers, body: jsonEncode({
      "username": username,
      "category": category,
      "page": page
    }));

    var usernames = List<String>.from(jsonDecode(response.body)["users"]);
    for (var username in usernames) {
      users.add(await getUser(username: username));
    }
    return users;
  }
}