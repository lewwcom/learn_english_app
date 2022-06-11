import 'package:collection/collection.dart';
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/models/definition.dart';

class Flashcard {
  // TODO: due time, e factor, interval

  final int? id;
  final Word word;
  final double? e_factor;
  final double? interval;

  /// [word] and [definition] will be cloned.
  Flashcard(Word word, Definition definition,
      {this.id, this.e_factor, this.interval})
      : word =
            Word(word.word, word.ipa, word.audioUrl, word.imgUrl, id: word.id) {
    this.word.addDefinition(Definition(
          definition.lexicalCategory,
          definition.meaning,
          definition.example,
          id: definition.id,
        ));
  }

  Definition get definition => word.definitions.first;
}

class FlashcardSerializer implements Serializer<Flashcard> {
  @override
  Flashcard fromJsonContentKey(content) => Flashcard(
      WordSerializer().fromJsonContentKey({
        "word": content["word"],
        "ipa": content["ipa"],
        "audio_url": content["audio_url"],
        "img_url": content["img_url"],
        "id": content["word_id"],
        "sys_defs": []
      }),
      DefinitionSerializer().fromJsonContentKey({
        "lexical_category": content["lexical_category"],
        "meaning": content["meaning"],
        "example": content["example"],
        "id": content["sys_def_id"]
      }),
      id: content["id"],
      e_factor: content["e_factor"],
      interval: content["interval"]);
}

class FlashcardEquality implements Equality<Flashcard> {
  @override
  bool equals(Flashcard? fc1, Flashcard? fc2) =>
      (fc1 == fc2) ||
      (fc1 != null &&
          fc2 != null &&
          fc1.id == fc2.id &&
          WordEquality().equals(fc1.word, fc2.word));

  @override
  int hash(Flashcard? flashcard) => flashcard != null
      ? flashcard.id.hashCode + WordEquality().hash(flashcard.word)
      : 0;

  @override
  bool isValidKey(Object? o) => o is Flashcard?;
}
