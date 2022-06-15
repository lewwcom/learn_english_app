import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/models/flashcard.dart';

Future<int> create(int deckId, int defId) => api_client.post(
    "cards", _CardIdSerializer(),
    formData: {"deck_id": deckId.toString(), "sys_def_id": defId.toString()});

Future<void> update(Flashcard flashcard) => api_client.put(
      "cards/${flashcard.id}",
      api_client.DiscardResponseContentSerializer(),
      formData: Definition.toJson(flashcard.definition),
    );

Future<Flashcard> read(int cardId) =>
    api_client.get("cards/$cardId", FlashcardSerializer());

class _CardIdSerializer implements Serializer<int> {
  @override
  int fromJsonContentKey(content) => content["id"];
}
