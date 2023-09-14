// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..username = json['username'] as String
  ..name = json['name'] as String
  ..password = json['password'] as String
  ..img = json['img'] as String
  ..email = json['email'] as String
  ..phone = json['phone'] as String
  ..facebook = json['facebook'] as String
  ..ig = json['ig'] as String
  ..memo = json['memo'] as String
  ..mood = json['mood'] as String
  ..lat = json['lat'] as String
  ..lng = json['lng'] as String
  ..statusdate = json['statusdate'] as String;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'password': instance.password,
      'img': instance.img,
      'email': instance.email,
      'phone': instance.phone,
      'facebook': instance.facebook,
      'ig': instance.ig,
      'memo': instance.memo,
      'mood': instance.mood,
      'lat': instance.lat,
      'lng': instance.lng,
      'statusdate': instance.statusdate,
    };
