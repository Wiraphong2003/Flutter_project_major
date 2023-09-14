import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  late String username;
  late String name;
  late String password;
  late String img;
  late String email;
  late String phone;
  late String facebook;
  late String ig;
  late String memo;
  late String mood;
  late String lat;
  late String lng;
  late String statusdate;
  
  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
