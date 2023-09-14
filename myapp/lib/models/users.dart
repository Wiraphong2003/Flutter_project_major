import 'package:json_annotation/json_annotation.dart';

import "user.dart";

part 'users.g.dart';

@JsonSerializable()
// class Users {
//   Users();

//   late List<User> users;

//   factory Users.fromJson(Map<String,dynamic> json) => _$UsersFromJson(json);
//   Map<String, dynamic> toJson() => _$UsersToJson(this);
// }

class Users {
  List<User> users;

  Users({required this.users});

  factory Users.fromJson(List<dynamic> json) {
    List<User> users = json.map((user) => User.fromJson(user)).toList();
    return Users(users: users);
  }
}
