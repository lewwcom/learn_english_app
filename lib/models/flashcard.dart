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
        definition.lexicalCategory, definition.meaning, definition.example,
        id: definition.id));
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
