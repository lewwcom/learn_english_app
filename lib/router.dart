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
import 'package:learn_english_app/pages/loading/loading_page.dart';
import 'package:learn_english_app/pages/search/search_page.dart';
import 'package:learn_english_app/pages/word/word_page.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/pages/youtube/youtube_page.dart';
import 'package:learn_english_app/services/api_deck.dart' as api_deck;

typedef _GetDeckAndFlashcard = Future<DeckAndFlashcard> Function();

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
        builder: (data) => WordPage(data),
      ),
    ),
    GoRoute(
      path: "/decks",
      builder: (context, state) => LoadingPage<List<Deck>>(
        // TODO: Change to lazy loading
        fetchResult: () async => Stream.fromIterable(await api_deck.readAll())
            .asyncMap((deck) async => await api_deck.read(deck.id!))
            .toList(),
        builder: (decks) => DecksPage(decks),
        refreshOnPopNext: true,
      ),
      routes: [
        GoRoute(
          path: ":deckId",
          builder: (context, state) => LoadingPage<Deck>(
            initialValue: state.extra is Deck ? state.extra as Deck : null,
            fetchResult: () async =>
                await api_deck.read(int.parse(state.params["deckId"]!)),
            builder: (deck) => DeckPage(deck),
            refreshOnPopNext: true,
          ),
          routes: [
            GoRoute(
                path: "cards",
                builder: (context, state) => LoadingPage<Deck>(
                      initialValue:
                          state.extra is Deck ? state.extra as Deck : null,
                      fetchResult: () async => await api_deck
                          .read(int.parse(state.params["deckId"]!)),
                      builder: (deck) => FlashcardsPage(deck,
                          searchQuery: state.queryParams["query"]),
                      refreshOnPopNext: true,
                    ),
                routes: [
                  GoRoute(
                    path: ":cardId",
                    builder: (context, state) => LoadingPage<DeckAndFlashcard>(
                      initialValue: state.extra is DeckAndFlashcard
                          ? state.extra as DeckAndFlashcard
                          : null,
                      fetchResult: () async {
                        if (state.extra is _GetDeckAndFlashcard) {
                          return await (state.extra as _GetDeckAndFlashcard)();
                        }
                        Deck deck = await api_deck
                            .read(int.parse(state.params["deckId"]!));
                        return DeckAndFlashcard(
                          deck,
                          deck.flashcards.firstWhere((card) =>
                              card.id == int.parse(state.params["cardId"]!)),
                        );
                      },
                      builder: (deckFlashcard) => FlashcardPage(deckFlashcard),
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
    GoRoute(path: "/homescreen", builder: (context, state) => HomeScreen())
  ],
);
