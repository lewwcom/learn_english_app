import '../api/serializer.dart';

class SignupResponse {
  bool? success;
  dynamic? content;

  SignupResponse({this.success = true, this.content = null});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    content = json['content'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['content'] = this.content;
    return data;
  }
}

class SignupSerializer implements Serializer<SignupResponse> {
  @override
  SignupResponse fromJsonContentKey(content) {
    SignupResponse signupResponse = SignupResponse(content: content);
    return signupResponse;
  }
}
