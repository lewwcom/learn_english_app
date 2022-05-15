import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_english_app/models/signup_response.dart';

import '../models/login_response.dart';
import '../models/login_resquest.dart';


class APILogin {
  Future<LoginResponse> login(LoginRequest requestModel) async {
    //String url = "http://localhost:5001/auth/login";
    String url = "http://10.0.2.2:5001/auth/login";
    print("---------------------");
    //String url = "https://61af70223e2aba0017c49342.mockapi.io/login";

    var map = new Map<String, dynamic>();
    map['username'] = requestModel.username;
    map['password'] = requestModel.password;
    map['password_password_confirmation'] = requestModel.password;

    final response = await http.post(Uri.parse(url), body: requestModel.toJson());
    final response1 = await http.post(Uri.parse("http://10.0.2.2:5001/auth/signup"), body: map);
    var xx = SignupResponse.fromJson(json.decode(response1.body));
    print("ssssssssssss");
    print(xx.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }

  }


}


