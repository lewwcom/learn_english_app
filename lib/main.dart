import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/deck/deck_page.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/deck/new_deck_page.dart';
import 'package:learn_english_app/pages/deck/words_in_deck_page.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';

import 'models/word.dart';

// TODO: TextTheme

void main() {
  testApiClient();
  runApp(App());
}

// TODO: Remove it
Future<void> testApiClient() async {
  await api_client.post(
    "auth/signup",
    {
      "username": "test_account",
      "password": "12345678",
      "password_confirmation": "12345678",
    },
  );
  await api_client.post(
    "auth/login",
    {"username": "test_account", "password": "12345678", "remember_me": "true"},
  );
  List<Word> words = await api_client.get("words/?word=ca", WordsSerializer());
  debugPrint(words.first.word);
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: "/decks",
    routes: [
      GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
      GoRoute(
        path: "/words/:word",
        builder: (context, state) =>
            WordPage(Word.fromString(state.params["word"]!)),
      ),
      GoRoute(
        path: "/decks",
        builder: (context, state) => const DecksPage(),
        routes: [
          GoRoute(
            path: ":deck",
            builder: (context, state) => DeckPage(DecksPage.decks.firstWhere(
                (deck) => deck.name.compareTo(state.params["deck"]!) == 0)),
            routes: [
              GoRoute(
                path: "words",
                builder: (context, state) => WordsInDeckPage(
                  DecksPage.decks.firstWhere((deck) =>
                      deck.name.compareTo(state.params["deck"]!) == 0),
                  searchBoxAutoFocus: state.queryParams["query"] != null,
                ),
              )
            ],
          )
        ],
      ),
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
            borderRadius: BorderRadius.circular(kRadius),
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
