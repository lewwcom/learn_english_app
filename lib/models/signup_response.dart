class SignupResponse {
  bool? success;
  List<String>? content;

  SignupResponse({this.success, this.content});

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
