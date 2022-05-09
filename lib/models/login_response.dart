class LoginResponse {
   bool? success;
   String? content;

   LoginResponse({this.success = true, this.content = "sssss"});

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