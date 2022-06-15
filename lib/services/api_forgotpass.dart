import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/models/forgot_response.dart';

import '../models/forgot_request.dart';

class APIForgot {
  Future<ForgotResponse> forgotPass(ForgotRequest requestModel) async {
    await api_client.removeCookie();
    try {
      await api_client.post(
        "auth/forgot-password",
        ForgotSerializer(),
        formData: {
          "username": requestModel.username!,
          "phone_number": requestModel.phoneNumber!,
        },
      );
      return ForgotResponse();
    } on ApiException catch (e) {
      debugPrint(e.toString());
      return ForgotResponse(success: false);
    }
  }
}
