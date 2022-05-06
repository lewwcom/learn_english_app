import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/decks/decks_page.dart';
import 'package:learn_english_app/pages/decks/new_deck_page.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';

import 'models/word.dart';

// TODO: TextTheme

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: "/decks",
    routes: [
      GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
      GoRoute(
        path: "/word/:word",
        builder: (context, state) =>
            WordPage(Word.fromString(state.params["word"]!)),
      ),
      GoRoute(path: "/decks", builder: (context, state) => DecksPage()),
      GoRoute(
        path: "/create-deck",
        builder: (context, state) => const NewDeckPage(),
      )
    ],
  );

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const buttonPadding =
        EdgeInsets.symmetric(vertical: kPadding / 2, horizontal: kPadding);
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        cardTheme: CardTheme(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: buttonPadding,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: buttonPadding,
          ),
        ),
      ),
    );
  }
}
