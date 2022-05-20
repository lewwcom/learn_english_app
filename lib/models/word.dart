import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/api/serializer.dart';

class Word {
  final int? id;
  final String word;
  final String ipa;
  final String? audioUrl;
  final String? imgUrl;
  final List<Definition> _defintions = List.empty(growable: true);

  Word(this.word, this.ipa, this.audioUrl, this.imgUrl, {this.id});

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

  List<Definition> get definitions => List.unmodifiable(_defintions);
}

class WordSerializer implements Serializer<Word> {
  @override
  Word fromJsonContentKey(dynamic content) {
    Word word = Word(content["word"], content["ipa"], content["audio_url"],
        content["img_url"],
        id: content["id"]);

    word._defintions.addAll(ListSerializer(DefinitionSerializer())
        .fromJsonContentKey(content["sys_defs"]));
    return word;
  }
}
