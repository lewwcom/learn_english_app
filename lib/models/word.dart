import 'package:collection/collection.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/api/serializer.dart';

class Word {
  final int? id;
  final String word;
  final String ipa;
  final String? audioUrl;
  final String? imgUrl;
  final String? viMeaning;
  final List<Definition> _defintions = List.empty(growable: true);

  Word(this.word, this.ipa, this.audioUrl, this.imgUrl,
      {this.id, this.viMeaning});

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
    Word word = Word(
      content["word"],
      content["ipa"],
      content["audio_url"],
      content["img_url"],
      id: content["id"],
      viMeaning: content["vi_meaning"],
    );

    word._defintions.addAll(ListSerializer(DefinitionSerializer())
        .fromJsonContentKey(content["sys_defs"]));
    return word;
  }
}

class WordEquality implements Equality<Word> {
  @override
  bool equals(Word? w1, Word? w2) =>
      (w1 == w2) ||
      (w1 != null &&
          w2 != null &&
          w1.id == w2.id &&
          w1.word == w2.word &&
          w1.ipa == w2.ipa &&
          w1.audioUrl == w2.audioUrl &&
          w1.imgUrl == w2.imgUrl &&
          DeepCollectionEquality(DefinitionEquality())
              .equals(w1._defintions, w2._defintions));

  @override
  int hash(Word? word) => word != null
      ? word.id.hashCode +
          word.word.hashCode +
          word.ipa.hashCode +
          word.audioUrl.hashCode +
          word.imgUrl.hashCode +
          DeepCollectionEquality(DefinitionEquality()).hash(word._defintions)
      : 0;

  @override
  bool isValidKey(Object? o) => o is Word?;
}
