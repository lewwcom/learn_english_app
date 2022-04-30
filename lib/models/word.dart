import 'package:learn_english_app/models/definition.dart';

class Word {
  final String word;
  final String ipa;
  final String audioUrl;
  final String inclusionImageUrl;
  final List<Definition> _defintions = List.empty(growable: true);

  Word(this.word, this.ipa, this.audioUrl, this.inclusionImageUrl);

  factory Word.fromString(String word) {
    Word result = Word(
      word,
      "/ipa/",
      "https://upload.wikimedia.org/wikipedia/commons/4/48/En-uk-hello.ogg",
      "https://picsum.photos/300/200",
    );
    Definition definition = Definition(
        "category", "Very long definition of the word", "This is an example.");
    result.addDefinition(definition);
    result.addDefinition(definition);
    result.addDefinition(definition);
    return result;
  }

  void addDefinition(Definition definition) {
    _defintions.add(definition);
  }

  List<Definition> get defintions => List.unmodifiable(_defintions);
}
