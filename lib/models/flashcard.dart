import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/models/definition.dart';

class Flashcard {
  final int? id;
  final Word word;
  final Definition definition;

  Flashcard(this.id, this.word, this.definition);
}

class FlashcardSerializer implements Serializer<Flashcard> {
  @override
  Flashcard fromJsonContentKey(content) => Flashcard(
        content["id"],
        WordSerializer().fromJsonContentKey(content["word"]),
        DefinitionSerializer().fromJsonContentKey(content["def"]),
      );
}
