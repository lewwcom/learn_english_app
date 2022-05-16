import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/deck/deck_page.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/deck/new_deck_page.dart';
import 'package:learn_english_app/pages/deck/words_in_deck_page.dart';
import 'package:learn_english_app/pages/loading/loading_page.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';

final GoRouter router = GoRouter(
  initialLocation: "/youtube",
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
    GoRoute(path: "/youtube", builder: (context, state) => YoutubeScreen())
  ],
);
