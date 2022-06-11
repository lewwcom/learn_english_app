import '../api/serializer.dart';

class LoginResponse {
  bool? success;
  dynamic? content;

  LoginResponse({this.success = true, this.content = null});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['content'] = this.content;
    return data;
  }
}

class LoginSerializer implements Serializer<LoginResponse> {
  @override
  LoginResponse fromJsonContentKey(content) {
    LoginResponse loginResponse = LoginResponse(content: content);
    return loginResponse;
  }
}
