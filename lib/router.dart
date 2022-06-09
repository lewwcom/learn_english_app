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
import 'package:learn_english_app/pages/learn/learn_decks_page.dart';
import 'package:learn_english_app/pages/loading/loading_page.dart';
import 'package:learn_english_app/pages/login/login_page.dart';
import 'package:learn_english_app/pages/login/signup_page.dart';
import 'package:learn_english_app/pages/login/splash.dart';
import 'package:learn_english_app/pages/profile/profile_screen.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/vision/vision_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';
import 'package:learn_english_app/services/api_learn.dart' as api_learn;
import 'package:learn_english_app/utilities/process_text_notifier.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:provider/provider.dart';

const String initialLocation = "/profile";

final ProcessTextNotifier _processTextNotifier = ProcessTextNotifier();

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GoRouter router = GoRouter(
    initialLocation: initialLocation,
    redirect: (state) => (_processTextNotifier.isStartedByProcessTextIntent &&
            !state.location.startsWith("/words"))
        ? "/words/${_processTextNotifier.processText}"
        : null,
    refreshListenable: _processTextNotifier,
    observers: [
      routeObserver
    ],
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
      GoRoute(path: "/homescreen", builder: (context, state) => const HomeScreen()),
      GoRoute(path: "/profile", builder: (context, state) => ProfileScreen()),
      GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
      GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
      GoRoute(path: "/splash", builder: (context, state) => SplashScreen()),
      GoRoute(path: "/vision", builder: (context, state) => VisionPage()),
      // GoRoute(
      //     path: "/decks-learn",
      //     builder: (context, state) => const LoadingPage<List<Deck>>(
      //         fetchResult: () async =>
      //             Stream.fromIterable(await api_learn.readAll())
      //                 .asyncMap((deck) async => await api_learn.read(deck.id!))
      //                 .toList(),
      //         builder: (decks) => LearnDecksPage(decks))),
      GoRoute(
        path: "/learn",
        builder: (context, state) => LoadingPage<List<Deck>>(
            fetchResult: () async => Stream.fromIterable(
                await api_learn.readLearnAll())
                .asyncMap((deck) async => await api_learn.readLearn(deck.id!))
                .toList(),
            builder: (context, decks) => LearnDecksPage(decks)),
      ),
    ]);

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
