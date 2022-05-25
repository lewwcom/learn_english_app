import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/signup_response.dart';
import '../models/signup_resquest.dart';

class APISignup {
  Future<SignupResponse> signup(SignupRequest requestModel) async {
    print("-------------------");
    //String url = "http://127.0.0.1:5001/auth/signup";
    String url = "http://10.0.3.2:5001/auth/signup";
    var signupResponse = new SignupResponse();
    print(requestModel.toJson());

    final response =
        await http.post(Uri.parse(url), body: requestModel.toJson());

    if (response.statusCode == 201 || response.statusCode == 400) {
      bool ss = json.decode(response.body)['success'];
      print(ss);
      signupResponse.success = ss;
      return signupResponse;
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
