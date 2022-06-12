import 'package:flutter/material.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/pages/loading/loading_page.dart';
import 'package:learn_english_app/services/api_deck.dart' as api_deck;
import 'package:learn_english_app/services/api_flashcard.dart' as api_flashcard;

class LoadingNotifier<T> extends ChangeNotifier {
  T? _result;
  Object? _error;
  bool _isDisposed = false;
  final Future<T> Function() _fetchResult;

  LoadingNotifier(this._fetchResult, {bool fetchOnCreate = true}) {
    if (fetchOnCreate) {
      fetch();
    }
  }

  Future<void> fetch({bool willNotify = true}) async {
    try {
      _result = await _fetchResult();
    } catch (e, stack) {
      _error = e;
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stack);
    }
    if (!_isDisposed && willNotify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  T? get result {
    if (_error != null) {
      throw _error!;
    }
    return _result;
  }
}

class DecksNotifier extends LoadingNotifier<List<Deck>>
    with ShouldNotifyAboutUpdateHelper {
  // set shouldNotifyAboutUpdate := true only if updation is occured by fetching
  // from backend server.

  static Future<Deck> _fetchDeck(int deckId) => api_deck.read(deckId);

  static Future<List<Deck>> _fetchAll() async =>
      await Stream.fromIterable(await api_deck.readAll())
          .asyncMap((deck) => _fetchDeck(deck.id!))
          .toList();

  Map<int, Deck>? _decks;

  DecksNotifier() : super(_fetchAll);

  @override
  Future<void> fetch({bool willNotify = true}) async {
    await super.fetch(willNotify: false);
    try {
      if (_result != null) {
        _decks = {for (Deck deck in _result!) deck.id!: deck};
      }
    } catch (e) {
      _error = e;
    }
    if (willNotify) {
      shouldNotifyAboutUpdate = true;
      notifyListeners();
    }
  }

  Future<Deck> _fetchById(int deckId, {bool willNotify = true}) async {
    if (_decks?.containsKey(deckId) ?? false) {
      _decks![deckId] = await _fetchDeck(deckId);
      if (willNotify) {
        shouldNotifyAboutUpdate = true;
        notifyListeners();
      }
      return _decks![deckId]!;
    }
    await fetch(willNotify: willNotify);
    return _decks![deckId]!;
  }

  DeckNotifier getDeckNotifier(int deckId) =>
      DeckNotifier._fromDecksNotifier(deckId, this);

  @override
  List<Deck>? get result {
    // _error, if any, will be throwns
    super.result;
    return _decks != null ? List.unmodifiable(_decks!.values) : null;
  }

  Deck? getDeck(int deckId) {
    // _error, if any, will be thrown
    super.result;
    return _decks?[deckId];
  }

  Future<Deck> createDeck(String deckName) async {
    _decks!;
    Deck deck = await api_deck.create(deckName);
    _decks![deck.id!] = deck;
    shouldNotifyAboutUpdate = false;
    notifyListeners();
    return deck;
  }

  Future<Deck> renameDeck(int deckId, String deckName) async {
    _decks![deckId]!;
    await api_deck.rename(deckId, deckName);
    Deck deck = _cloneDeck(deckId, newName: deckName);
    _decks![deckId] = deck;
    shouldNotifyAboutUpdate = false;
    notifyListeners();
    return deck;
  }

  Future<Deck> deleteDeck(int deckId) async {
    _decks![deckId]!;
    await api_deck.delete(deckId);
    Deck deck = _decks!.remove(deckId)!;
    shouldNotifyAboutUpdate = false;
    notifyListeners();
    return deck;
  }

  Future<Flashcard> _createCard(int deckId, Flashcard flashcard) async {
    Deck deck = _cloneDeck(deckId);
    flashcard = Flashcard(
      flashcard.word,
      flashcard.definition,
      id: await api_flashcard.create(deckId, flashcard.definition.id!),
    );
    deck.addCard(flashcard);
    _decks![deckId] = deck;
    shouldNotifyAboutUpdate = false;
    notifyListeners();
    return flashcard;
  }

  Future<void> _replaceCard(int deckId, int cardId, Flashcard flashcard) async {
    Deck deck = _cloneDeck(deckId);
    if (deck.replaceCard(cardId, flashcard)) {
      await api_flashcard.update(flashcard);
      _decks![deckId] = deck;
      shouldNotifyAboutUpdate = false;
      notifyListeners();
    }
  }

  Deck _cloneDeck(int deckId, {String? newName}) {
    Deck deck = Deck(newName ?? _decks![deckId]!.name, id: deckId);
    deck.addCards(_decks![deckId]!.flashcards);
    return deck;
  }
}

class DeckNotifier extends LoadingNotifier<Deck> {
  final DecksNotifier _decksNotifier;
  final int _deckId;

  DeckNotifier._fromDecksNotifier(int deckId, DecksNotifier decksNotifier)
      : _decksNotifier = decksNotifier,
        _deckId = deckId,
        super(() => decksNotifier._fetchById(deckId), fetchOnCreate: false) {
    _result = decksNotifier.getDeck(deckId);
    decksNotifier.addListener(notifyListeners);
  }

  @override
  Future<void> fetch({bool willNotify = true}) =>
      _decksNotifier._fetchById(_deckId, willNotify: willNotify);

  @override
  Deck? get result => _decksNotifier.getDeck(_deckId);

  Future<Flashcard> createCard(Flashcard flashcard) =>
      _decksNotifier._createCard(_deckId, flashcard);

  Future<void> replaceCard(int cardId, Flashcard flashcard) =>
      _decksNotifier._replaceCard(_deckId, cardId, flashcard);

  @override
  void dispose() {
    _decksNotifier.removeListener(notifyListeners);
    super.dispose();
  }
}
