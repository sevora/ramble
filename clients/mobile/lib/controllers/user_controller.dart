import 'dart:convert';

import 'package:http/http.dart' as http;
import '../environment.dart';
import '../models/user_model.dart';

class UserController {
  UserController();

  final Map<String, String> _headers = {
    'content-type': 'application/json',
    'response-type': 'application/json',
  };

  UserModel? _user;

  get user {
    return _user;
  }

  get loggedIn {
    return _user != null;
  }

  Future<UserModel> _getActiveUser() async {
    var uri = Uri.http(Environment.serverURL, "/view");
    var response = await http.post(uri, headers: _headers);
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  login({required String usernameOrEmail, required String password}) async {
    var uri = Uri.http(Environment.serverURL, "/login");
    var response = await http.post(uri, headers: _headers, body: {
      usernameOrEmail,
      password
    });

    String? cookie = response.headers["set-cookie"];
    if (cookie != null) {
      int index = cookie.indexOf(";");
      _headers['cookie'] = (index == -1) ? cookie : cookie.substring(0, index);
      _user = await _getActiveUser();
    }
  }

  logout() async {
    var uri = Uri.http(Environment.serverURL, "/login");
    var response = await http.post(uri, headers: _headers);
    if (response.statusCode == 200) {
      _headers.remove("cookie");
      _user = null;
    }
  }

  Future<UserModel> view({ String? username }) async {
    var uri = Uri.http(Environment.serverURL, "/view");
    var response = await http.post(uri, headers: _headers, body: {
      "username": username ?? _user?.userName,
    });
    var body = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJSONAPI(body);
  }

  signUp({ required String username, required String email, required String password }) async {
    var uri = Uri.http(Environment.serverURL, "/signup");
    var response = await http.post(uri, headers: _headers, body: {
      username,
      email,
      password
    });
    if (response.statusCode == 200) {
      await login(usernameOrEmail: username, password: password);
      _user = await _getActiveUser();
    }
  }

  update({ String? userCommonName, String? biography }) async {
    var uri = Uri.http(Environment.serverURL, "/update");
    var response = await http.post(uri, headers: _headers, body: {
      userCommonName,
      biography
    });
    if (response.statusCode == 200) {
      _user = await _getActiveUser();
    }
  }

  delete() async {
    var uri = Uri.http(Environment.serverURL, "/delete");
    var response = await http.post(uri, headers: _headers);
    if (response.statusCode == 200) {
      _user = null;
    }
  }
}