import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_english_app/models/signup_response.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';

import '../models/login_response.dart';
import '../models/login_resquest.dart';

class APILogin {
  Future<LoginResponse> login(LoginRequest requestModel) async {
    // //String url = "http://localhost:5001/auth/login";
    // String url = "http://10.0.3.2:5001/auth/login";
    // print("---------------------");
    // //String url = "https://61af70223e2aba0017c49342.mockapi.io/login";

    // var map = new Map<String, dynamic>();
    // map['username'] = requestModel.username;
    // map['password'] = requestModel.password;
    // map['password_password_confirmation'] = requestModel.password;

    // final response =
    //     await http.post(Uri.parse(url), body: requestModel.toJson());
    // final response1 = await http
    //     .post(Uri.parse("http://10.0.3.2:5001/auth/signup"), body: map);
    // var xx = SignupResponse.fromJson(json.decode(response1.body));
    // print("ssssssssssss");
    // print(xx.toJson());

    // if (response.statusCode == 200 || response.statusCode == 400) {
    //   return LoginResponse.fromJson(
    //     json.decode(response.body),
    //   );
    // } else {
    //   throw Exception('Failed to load data!');
    // }
    var map = new Map<String, dynamic>();
    map['username'] = requestModel.username;
    map['password'] = requestModel.password;
    map['password_password_confirmation'] = requestModel.password;
    await api_client.removeCookie();
    try {
      await api_client.post(
        "auth/login",
        api_client.DiscardResponseContentSerializer(),
        formData: {
          "username": map['username'],
          "password": map['password'],
          "remember_me": "true"
        },
      );
      return LoginResponse();
    } on ApiException catch (e) {
      debugPrint(e.toString());
      return LoginResponse(success: false);
    }
  }
}
