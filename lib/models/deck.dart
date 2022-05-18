import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/word.dart';

class Deck {
  final int? id;
  final String name;
  final List<Flashcard> _flashcards = List.empty(growable: true);

  Deck(this.id, this.name);

  factory Deck.fromWordList(String name, List<Word> words) {
    Deck deck = Deck(null, name);
    deck._flashcards.addAll(
        words.map((word) => Flashcard(null, word, word.definitions.first)));
    return deck;
  }

  void addCard(Flashcard flashcard) {
    _flashcards.add(flashcard);
  }

  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);
}
