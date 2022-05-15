import 'package:flutter/material.dart';
import 'package:learn_english_app/pages/changepassword/change_password_page.dart';
import 'package:learn_english_app/pages/login/login_page.dart';
import 'package:learn_english_app/pages/login/signup_page.dart';
import 'package:learn_english_app/pages/login/splash.dart';
import 'package:learn_english_app/pages/search/search_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChangePasswordPage(),
    routes: {
      'register': (context) => SignupPage(),
      'login': (context) => LoginPage(),
      'splash': (context) => SplashScreen(),
      'search': (context) => SearchPage(),
      'changepassword': (context) => ChangePasswordPage(),
    },
  ));
}