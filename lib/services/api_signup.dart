import 'package:flutter/cupertino.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import '../api/api_exception.dart';
import '../models/signup_response.dart';
import '../models/signup_resquest.dart';

class APISignup {

  Future<SignupResponse> signup(SignupRequest requestModel) async {
    try {
      await api_client.post(
        "/auth/signup",
        //"http://10.0.2.2:5001/auth/signup",
        SignupSerializer(),
        formData: {
          "username": requestModel.username!,
          "password": requestModel.password!,
          "password_confirmation": requestModel.password_confirmation!,
          "email": requestModel.email!,
        },
      );
      return SignupResponse();
    } on ApiException catch (e) {
      debugPrint(e.toString());
      return SignupResponse(success: false);
    }
  }
}
