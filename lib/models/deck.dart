import 'package:collection/collection.dart';
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/word.dart';

class Deck {
  final int? id;
  final String name;
  final List<Flashcard> _flashcards = List.empty(growable: true);

  Deck(this.name, {this.id});

  factory Deck.fromWordList(String name, List<Word> words) {
    Deck deck = Deck(name);
    deck._flashcards
        .addAll(words.map((word) => Flashcard(word, word.definitions.first)));
    return deck;
  }

  void addCard(Flashcard flashcard) => _flashcards.add(flashcard);

  void addCards(Iterable<Flashcard> cards) => _flashcards.addAll(cards);

  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);

  bool replaceCard(int cardId, Flashcard flashcard) {
    int index = _flashcards.indexWhere((card) => card.id == cardId);
    if (index < 0) {
      return false;
    }
    _flashcards[index] = flashcard;
    return true;
  }
}

class DeckSerializer implements Serializer<Deck> {
  @override
  Deck fromJsonContentKey(content) {
    Deck deck = Deck(content["name"], id: content["id"]);
    if (content["cards"] != null) {
      deck._flashcards.addAll(ListSerializer(FlashcardSerializer())
          .fromJsonContentKey(content["cards"]));
    }
    return deck;
  }
}

class DeckEquality implements Equality<Deck> {
  @override
  bool equals(Deck? d1, Deck? d2) =>
      (d1 == d2) ||
      (d1 != null &&
          d2 != null &&
          d1.id == d2.id &&
          d1.name == d2.name &&
          DeepCollectionEquality.unordered(FlashcardEquality())
              .equals(d1._flashcards, d2.flashcards));

  @override
  int hash(Deck? deck) => deck != null
      ? deck.id.hashCode +
          deck.name.hashCode +
          DeepCollectionEquality.unordered(FlashcardEquality())
              .hash(deck._flashcards)
      : 0;

  @override
  bool isValidKey(Object? o) => o is Deck?;
}
