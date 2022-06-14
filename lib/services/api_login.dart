import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';

import '../models/login_response.dart';
import '../models/login_resquest.dart';

class APILogin {
  Future<LoginResponse> login(LoginRequest requestModel) async {
    await api_client.removeCookie();
    try {
      await api_client.post(
        "auth/login",
        //"http://10.0.2.2:5001/auth/login",
        LoginSerializer(),
        formData: {
          "username": requestModel.username!,
          "password": requestModel.password!,
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
