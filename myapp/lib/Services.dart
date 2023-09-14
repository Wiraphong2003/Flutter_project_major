import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/user.dart';

import 'models/users.dart';

class Services {
  static const String url = "https://plain-ruby-piranha.cyclic.app/user";
  // static const String url = "http://localhost:3000/user";
  // static Future<Users> getUsers() async {
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (200 == response.statusCode) {
  //       return parseUsers(response.body);
  //     } else {
  //       return Users(users: []);
  //     }
  //   } catch (e) {
  //     print('Error ${e.toString()}');
  //     return Users(users: []);
  //   }
  // }
  static Future<Users> getUsers() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        return parseUsers(response.body);
      } else {
        return Users(users: []);
      }
    } catch (e) {
      print('Error ${e.toString()}');
      return Users(users: []);
    }
  }

  static Users parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<User> users = parsed.map<User>((json) => User.fromJson(json)).toList();
    return Users(users: users);
  }

  // static Users parseUsers(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   List<User> users = parsed.map<User>((json) => User.fromJson(json)).toList();
  //   Users u = Users(users: []);
  //   u.users = users;
  //   return u;
  // }
}
