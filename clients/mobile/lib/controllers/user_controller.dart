import 'dart:convert';

import 'package:http/http.dart' as http;
import '../environment.dart';
import '../models/user_model.dart';

class UserController {
  Map<String, String> headers = {
    'content-type': 'application/json',
    'response-type': 'application/json',
  };

  UserModel? user;
  bool hasLoggedIn = false;

  UserController();

  login(String username, String password) async {
    var uri = Uri.http(Environment.serverURL, "/login");
    var response = await http.post(uri, headers: headers, body: {
      username,
      password
    });

    String? cookie = response.headers["set-cookie"];
    if (cookie != null) {
      int index = cookie.indexOf(";");
      headers['cookie'] = (index == -1) ? cookie : cookie.substring(0, index);
      user = await _getActiveUser();
      hasLoggedIn = true;
    }
  }

  logout() async {
    var uri = Uri.http(Environment.serverURL, "/login");
    var response = await http.post(uri, headers: headers);
    if (response.statusCode == 200) {
      headers.remove("cookie");
      user = null;
      hasLoggedIn = false;
    }

  }

  Future<UserModel> _getActiveUser() async {
    var uri = Uri.http(Environment.serverURL, "/view");
    var response = await http.post(uri, headers: headers);
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  Future<UserModel> view({ String? username }) async {
    var uri = Uri.http(Environment.serverURL, "/view");
    var response = await http.post(uri, headers: headers, body: {
      "username": username ?? user?.userName,
    });
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }
}