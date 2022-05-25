import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/deck/deck_page.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/deck/new_deck_page.dart';
import 'package:learn_english_app/pages/deck/words_in_deck_page.dart';
import 'package:learn_english_app/pages/home/home_screen.dart';
import 'package:learn_english_app/pages/learn/learn_decks_page.dart';
import 'package:learn_english_app/pages/learn/learn_page.dart';
import 'package:learn_english_app/pages/loading/loading_page.dart';
import 'package:learn_english_app/pages/login/login_page.dart';
import 'package:learn_english_app/pages/login/signup_page.dart';
import 'package:learn_english_app/pages/login/splash.dart';
import 'package:learn_english_app/pages/profile/profile_screen.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';
import 'package:learn_english_app/services/api_learn.dart' as api_learn;

final GoRouter router = GoRouter(
  // initialLocation: "/youtube",
  initialLocation: "/learn",
  routes: [
    GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
    GoRoute(
      path: "/words/:word",
      builder: (context, state) => LoadingPage<Word>(
        fetchResult: () async {
          // TODO: Change to words/:id
          if (state.extra is Word) {
            return state.extra as Word;
          }
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
                fetchResult: () async => DecksPage.decks.firstWhere(
                    (deck) => deck.name.compareTo(state.params["deck"]!) == 0),
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
    ),
    GoRoute(path: "/youtube", builder: (context, state) => YoutubeScreen()),
    GoRoute(path: "/homescreen", builder: (context, state) => HomeScreen()),
    GoRoute(path: "/profile", builder: (context, state) => ProfileScreen()),
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
    GoRoute(path: "/splash", builder: (context, state) => SplashScreen()),
    // GoRoute(
    //     path: "/decks-learn",
    //     builder: (context, state) => const LoadingPage<List<Deck>>(
    //         fetchResult: () async =>
    //             Stream.fromIterable(await api_learn.readAll())
    //                 .asyncMap((deck) async => await api_learn.read(deck.id!))
    //                 .toList(),
    //         builder: (decks) => LearnDecksPage(decks))),
    GoRoute(path: "/learn", builder: (context, state) => LearnDecksPage())
  ],
);
