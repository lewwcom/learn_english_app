import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/models/forgot_response.dart';

class APIForgot {
  Future<ForgotResponse> forgotPass() async {
    await api_client.removeCookie();
    try {
      await api_client.post(
        "auth/forgot-password",
        ForgotSerializer(),
        formData: {},
      );
      return ForgotResponse();
    } on ApiException catch (e) {
      debugPrint(e.toString());
      return ForgotResponse(success: false);
    }
  }
}
