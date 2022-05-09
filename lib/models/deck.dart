import 'package:learn_english_app/models/word.dart';

class Deck {
  final String _name;
  final List<Word> _words = List.empty(growable: true);

  Deck(this._name);

  factory Deck.fromWordList(String name, List<Word> words) {
    Deck deck = Deck(name);
    deck._words.addAll(words);
    return deck;
  }

  String get name => _name;

  void addWord(Word word) {
    _words.add(word);
  }

  List<Word> get words => List.unmodifiable(_words);
}
