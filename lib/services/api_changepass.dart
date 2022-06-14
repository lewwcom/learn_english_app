import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/models/change_password_request.dart';
import 'package:learn_english_app/models/change_password_response.dart';
import 'package:learn_english_app/models/forgot_response.dart';

import '../models/forgot_request.dart';

class APIChangePass {
  Future<ChangePasswordResponse> changePass(
      ChangePasswordResquest requestModel) async {
    try {
      await api_client.post(
        "auth/change-password",
        ChangePasswordSerializer(),
        formData: {
          "current_password": requestModel.password!,
          "new_password": requestModel.newPassword!,
          "password_confirmation": requestModel.passwordConfirmation!
        },
      );
      return ChangePasswordResponse();
    } on ApiException catch (e) {
      debugPrint(e.toString());
      return ChangePasswordResponse(success: false);
    }
  }
}
