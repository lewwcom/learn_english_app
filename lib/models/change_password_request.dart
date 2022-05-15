class ChangePasswordResquest {
  String? password;
  String? passwordConfirmation;
  String? newPassword;

  ChangePasswordResquest(
      {this.password, this.passwordConfirmation, this.newPassword});

  ChangePasswordResquest.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    newPassword = json['new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    data['new_password'] = this.newPassword;
    return data;
  }
}