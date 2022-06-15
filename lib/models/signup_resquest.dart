class SignupRequest {
  String? username;
  String? email;
  String? password;
  String? password_confirmation;
  String? phone_number;

  SignupRequest(
      {this.username,
      this.email,
      this.password,
      this.password_confirmation,
      this.phone_number});

  SignupRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    password_confirmation = json['password_confirmation'];
    phone_number = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.password_confirmation;
    data['phone_number'] = this.phone_number;
    return data;
  }
}
