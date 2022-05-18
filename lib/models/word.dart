import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/api/serializer.dart';

class Word {
  final int? id;
  final String word;
  final String ipa;
  final String? audioUrl;
  final String? imgUrl;
  final List<Definition> _defintions = List.empty(growable: true);

  Word(this.id, this.word, this.ipa, this.audioUrl, this.imgUrl);

  factory Word.fromString(String word) {
    Word result = Word(
      null,
      word,
      "/ipa/",
      "https://upload.wikimedia.org/wikipedia/commons/4/48/En-uk-hello.ogg",
      "https://picsum.photos/300/200",
    );
    Definition definition = Definition(null, "category",
        "Very long definition of the word", "This is an example.");
    result.addDefinition(definition);
    result.addDefinition(definition);
    result.addDefinition(definition);
    return result;
  }

  void addDefinition(Definition definition) {
    _defintions.add(definition);
  }

  List<Definition> get definitions => List.unmodifiable(_defintions);
}

class WordSerializer implements Serializer<Word> {
  @override
  Word fromJsonContentKey(dynamic content) {
    Word word = Word(content["id"], content["word"], content["ipa"],
        content["audio_url"], content["img_url"]);

    final DefinitionSerializer definitionSerializer = DefinitionSerializer();
    word._defintions.addAll((content["sys_defs"] as List<dynamic>)
        .map((def) => definitionSerializer.fromJsonContentKey(def))
        .toList());
    return word;
  }
}

class WordsSerializer implements Serializer<List<Word>> {
  @override
  List<Word> fromJsonContentKey(dynamic content) {
    final WordSerializer wordSerializer = WordSerializer();
    return (content as List<dynamic>)
        .map((word) => wordSerializer.fromJsonContentKey(word))
        .toList();
  }
}
