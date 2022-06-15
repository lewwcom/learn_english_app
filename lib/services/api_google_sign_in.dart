import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/models/login_response.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static bool checkGoogleSigin = false;
  static setGoogleSigin() {
    if (checkGoogleSigin == true) {
      checkGoogleSigin = false;
    } else {
      checkGoogleSigin = true;
    }
  }

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.disconnect();

  static Future<LoginResponse> sendToBack(String? accessToken) async {
    await api_client.removeCookie();
    try {
      await api_client.post(
        "auth/google-login",
        //"http://10.0.2.2:5001/auth/login",
        LoginSerializer(),
        formData: {"access_token": accessToken!},
      );
      return LoginResponse();
    } on ApiException catch (e) {
      debugPrint(e.toString());
      return LoginResponse(success: false);
    }
  }
}
