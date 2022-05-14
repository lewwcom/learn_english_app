import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/pages/deck/deck_page.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/deck/new_deck_page.dart';
import 'package:learn_english_app/pages/deck/words_in_deck_page.dart';
import 'package:learn_english_app/pages/loading/loading_page.dart';
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

  /* try {
    List<Word> words =
        await api_client.get("words/?word=ca", WordsSerializer());
    debugPrint(words.first.word);
  } on ApiException catch (e) {
    debugPrint(e.toString());
  } */
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: "/search",
    routes: [
      GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
      GoRoute(
        path: "/words/:word",
        builder: (context, state) => LoadingPage<Word>(
          fetchResult: () async {
            // TODO: Change to words/:id
            List<Word> words = await api_client.get(
                "words/?word=${state.params["word"]}", WordsSerializer());
            return words.first;
          },
          builder: (data) => WordPage(data),
        ),
      ),
      GoRoute(
        path: "/decks",
        builder: (context, state) => const DecksPage(),
        routes: [
          GoRoute(
            path: ":deck",
            builder: (context, state) => LoadingPage<Deck>(
              // TODO: Use API
              fetchResult: () async => DecksPage.decks.firstWhere(
                  (deck) => deck.name.compareTo(state.params["deck"]!) == 0),
              builder: (deck) => DeckPage(deck),
            ),
            routes: [
              GoRoute(
                path: "words",
                builder: (context, state) => LoadingPage<Deck>(
                  // TODO: Use API
                  fetchResult: () async => DecksPage.decks.firstWhere((deck) =>
                      deck.name.compareTo(state.params["deck"]!) == 0),
                  builder: (deck) => WordsInDeckPage(deck,
                      searchQuery: state.queryParams["query"]),
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
