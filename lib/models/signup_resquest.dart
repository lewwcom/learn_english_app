class SignupRequest {
  String? username;
  String? email;
  String? password;
  String? password_confirmation;

  SignupRequest({this.username, this.email, this.password, this.password_confirmation});

  SignupRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    password_confirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.password_confirmation;
    return data;
  }
}