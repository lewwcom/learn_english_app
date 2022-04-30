import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';

import 'models/word.dart';

// TODO: TextTheme

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: "/search",
    routes: [
      GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
      GoRoute(
        path: "/word/:word",
        builder: (context, state) =>
            WordPage(Word.fromString(state.params["word"]!)),
      ),
    ],
  );

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      );
}
