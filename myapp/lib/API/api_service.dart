import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/index.dart';

class APIService {
  // Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
  //   String url = "https://plain-ruby-piranha.cyclic.app/login";
  static const String url = "https://plain-ruby-piranha.cyclic.app/user";
  static const String groupurl =
      "https://plain-ruby-piranha.cyclic.app/Group/Max";

  //   final response = await http.post(url as Uri, body: requestModel.toJson());
  //   if (response.statusCode == 200 || response.statusCode == 400) {
  //     return LoginResponseModel.fromJson(
  //       json.decode(response.body),
  //     );
  //   } else {
  //     throw Exception('Failed to load data!');
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

  static Future<Groups> getGroups() async {
    try {
      final response = await http.get(Uri.parse(groupurl));
      if (200 == response.statusCode) {
        return parseGroup(response.body);
      } else {
        return Groups(groups: []);
      }
    } catch (e) {
      print('Error ${e.toString()}');
      return Groups(groups: []);
    }
  }

  static Groups parseGroup(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Group> groups =
        parsed.map<Group>((json) => Group.fromJson(json)).toList();
    return Groups(groups: groups);
  }
}
