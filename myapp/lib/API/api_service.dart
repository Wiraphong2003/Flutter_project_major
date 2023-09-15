import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    String url = "https://plain-ruby-piranha.cyclic.app/login";

    final response = await http.post(url as Uri, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
