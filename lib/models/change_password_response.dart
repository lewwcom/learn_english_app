import 'package:learn_english_app/api/serializer.dart';

class ChangePasswordResponse {
  bool? success;
  dynamic? content;

  ChangePasswordResponse({this.success = true, this.content = null});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
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

class ChangePasswordSerializer implements Serializer<ChangePasswordResponse> {
  @override
  ChangePasswordResponse fromJsonContentKey(content) {
    ChangePasswordResponse forgotResponse =
        ChangePasswordResponse(content: content);
    return forgotResponse;
  }
}
