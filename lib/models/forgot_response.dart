import 'package:learn_english_app/api/serializer.dart';

class ForgotResponse {
  bool? success;
  dynamic? content;

  ForgotResponse({this.success = true, this.content = null});

  ForgotResponse.fromJson(Map<String, dynamic> json) {
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

class ForgotSerializer implements Serializer<ForgotResponse> {
  @override
  ForgotResponse fromJsonContentKey(content) {
    ForgotResponse forgotResponse = ForgotResponse(content: content);
    return forgotResponse;
  }
}
