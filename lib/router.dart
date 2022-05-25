import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/deck/deck_page.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/deck/new_deck_page.dart';
import 'package:learn_english_app/pages/deck/flashcards_page.dart';
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
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';
import 'package:learn_english_app/services/api_deck.dart' as api_deck;
import 'package:learn_english_app/utilities/process_text_notifier.dart';

const String initialLocation = "/decks";

final ProcessTextNotifier _processTextNotifier = ProcessTextNotifier();

final GoRouter router = GoRouter(
  initialLocation: initialLocation,
  redirect: (state) => (_processTextNotifier.isStartedByProcessTextIntent &&
          !state.location.startsWith("/words"))
      ? "/words/${_processTextNotifier.processText}"
      : null,
  refreshListenable: _processTextNotifier,
  routes: [
    GoRoute(path: "/search", builder: (context, state) => const SearchPage()),
    GoRoute(
      path: "/words/:word",
      builder: (context, state) => LoadingPage<Word>(
        fetchResult: () async {
          if (state.extra is Word) {
            return state.extra as Word;
          }
          List<Word> words = await api_client.get(
              "words/?word=${state.params["word"]}",
              ListSerializer(WordSerializer()));
          return words.first;
        },
        builder: (data) => WordPage(data),
      ),
    ),
    GoRoute(
      path: "/decks",
      builder: (context, state) => LoadingPage<List<Deck>>(
          fetchResult: () async => Stream.fromIterable(await api_deck.readAll())
              .asyncMap((deck) async => await api_deck.read(deck.id!))
              .toList(),
          builder: (decks) => DecksPage(decks)),
      routes: [
        GoRoute(
          path: ":deck",
          builder: (context, state) => DeckPage(state.extra as Deck),
          routes: [
            GoRoute(
                path: "cards",
                builder: (context, state) => FlashcardsPage(state.extra as Deck,
                    searchQuery: state.queryParams["query"]),
                routes: [
                  GoRoute(
                    path: ":card",
                    builder: (context, state) => LoadingPage<DeckAndFlashcard>(
                      fetchResult: () async {
                        debugPrint(state.extra.runtimeType.toString());
                        if (state.extra is Future<DeckAndFlashcard>
                            Function()) {
                          return await (state.extra as Future<DeckAndFlashcard>
                              Function())();
                        }
                        return state.extra as DeckAndFlashcard;
                      },
                      builder: (deckAndFlashcard) =>
                          FlashcardPage(deckAndFlashcard),
                    ),
                  ),
                ])
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
