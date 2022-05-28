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

  void addCard(Flashcard flashcard) {
    _flashcards.add(flashcard);
  }

  void removeFirst() {
    _flashcards.removeAt(0);
  }

  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);
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
