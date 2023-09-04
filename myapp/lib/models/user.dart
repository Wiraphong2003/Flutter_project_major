import 'package:json_annotation/json_annotation.dart';
import "address.dart";
import "company.dart";
part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  late num id;
  late String name;
  late String username;
  late String email;
  late Address address;
  late String phone;
  late String website;
  late Company company;
  late String img;
  
  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
