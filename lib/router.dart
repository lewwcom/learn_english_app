import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/main.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/deck/deck_page.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/deck/new_deck_page.dart';
import 'package:learn_english_app/pages/deck/flashcards_page.dart';
import 'package:learn_english_app/pages/home/home_screen.dart';
import 'package:learn_english_app/pages/loading/loading_page.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:provider/provider.dart';

const String initialLocation = "/decks";

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GoRouter router = GoRouter(
  initialLocation: initialLocation,
  observers: [routeObserver],
  routes: [
    GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
    GoRoute(
      path: "/words/:word",
      builder: (context, state) => LoadingPage<Word>(
        initialValue: state.extra is Word ? state.extra as Word : null,
        fetchResult: () async => (await api_client.get(
                "words/?word=${state.params["word"]}",
                ListSerializer(WordSerializer())))
            .first,
        builder: (context, data) => WordPage(data),
      ),
    ),
    GoRoute(
      path: "/decks",
      builder: (context, state) => LoadingPage<List<Deck>>(
        loadingNotifier: decksNotifier,
        equality: DeepCollectionEquality.unordered(DeckEquality()),
        notifyAboutChangeText: "Decks updated from server!",
        builder: (context, decks) => DecksPage(decks),
        refreshOnPopNext: true,
      ),
      routes: [
        GoRoute(
          path: ":deckId",
          builder: (context, state) => LoadingPage<Deck>(
            loadingNotifier: decksNotifier
                .getDeckNotifier(int.parse(state.params["deckId"]!)),
            willDisposeNotifier: true,
            builder: (context, deck) => DeckPage(deck),
            refreshOnPopNext: true,
          ),
          routes: cardsRoute,
        )
      ],
    ),
    GoRoute(
      path: "/create-deck",
      builder: (context, state) => ChangeNotifierProvider.value(
          value: decksNotifier, child: const NewDeckPage()),
    ),
    GoRoute(path: "/youtube", builder: (context, state) => YoutubeScreen()),
    GoRoute(path: "/homescreen", builder: (context, state) => HomeScreen())
  ],
);

List<GoRoute> cardsRoute = [
  GoRoute(
      path: "cards",
      builder: (context, state) => LoadingPage<Deck>(
            loadingNotifier: decksNotifier
                .getDeckNotifier(int.parse(state.params["deckId"]!)),
            willDisposeNotifier: true,
            builder: (context, deck) =>
                FlashcardsPage(deck, searchQuery: state.queryParams["query"]),
            refreshOnPopNext: true,
          ),
      routes: [
        GoRoute(
          path: ":cardId",
          builder: (context, state) => LoadingPage<Deck>(
            loadingNotifier: decksNotifier
                .getDeckNotifier(int.parse(state.params["deckId"]!)),
            willDisposeNotifier: true,
            builder: (context, decks) => LoadingPage<Flashcard>(
              fetchResult: () async => state.extra is Flashcard
                  ? await _getDeckNotifier(context)
                      .createCard(state.extra as Flashcard)
                  : _getDeckNotifier(context).result!.flashcards.firstWhere(
                      (card) => card.id == int.parse(state.params["cardId"]!)),
              builder: (context, flashcard) =>
                  FlashcardPage(_getDeckNotifier(context).result!, flashcard),
            ),
          ),
        ),
      ])
];

DeckNotifier _getDeckNotifier(BuildContext context) =>
    (context.read<LoadingNotifier<Deck>>() as DeckNotifier);
