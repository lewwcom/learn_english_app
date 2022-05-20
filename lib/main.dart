import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/router.dart';
import 'package:learn_english_app/theme_data.dart';

// TODO: TextTheme

Future<void> main() async {
  await loginTestAccount();
  runApp(const App());
}

// TODO: Remove it
Future<void> loginTestAccount() async {
  await api_client.removeCookie();

  try {
    await api_client.post(
      "auth/signup",
      api_client.DiscardResponseContentSerializer(),
      formData: {
        "username": "test_account",
        "password": "12345678",
        "password_confirmation": "12345678",
      },
    );
  } on ApiException catch (e) {
    debugPrint(e.toString());
  }

  try {
    await api_client.post(
      "auth/login",
      api_client.DiscardResponseContentSerializer(),
      formData: {
        "username": "test_account",
        "password": "12345678",
        "remember_me": "true"
      },
    );
  } on ApiException catch (e) {
    debugPrint(e.toString());
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        theme: themeData,
      );
}
