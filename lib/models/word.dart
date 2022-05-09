import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/models/serializer.dart';

class Word {
  final String word;
  final String ipa;
  final String? audioUrl;
  final String? imgUrl;
  final List<Definition> _defintions = List.empty(growable: true);

  Word(this.word, this.ipa, this.audioUrl, this.imgUrl);

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

class WordSerializer implements Serializer<Word> {
  @override
  Word fromJson(Map<String, dynamic> json) {
    Word word =
        Word(json["word"], json["ipa"], json["audio_url"], json["img_url"]);

    final DefinitionSerializer definitionSerializer = DefinitionSerializer();
    word._defintions.addAll((json["sys_defs"] as List<dynamic>)
        .map((def) => definitionSerializer.fromJson(def))
        .toList());
    return word;
  }
}

class WordsSerializer implements Serializer<List<Word>> {
  @override
  List<Word> fromJson(Map<String, dynamic> json) {
    final WordSerializer wordSerializer = WordSerializer();
    return (json["content"] as List<dynamic>)
        .map((word) => wordSerializer.fromJson(word))
        .toList();
  }
}
