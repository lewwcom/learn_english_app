class ForgotRequest {
  String? username;
  String? phoneNumber;

  ForgotRequest({this.username, this.phoneNumber});

  ForgotRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }

}