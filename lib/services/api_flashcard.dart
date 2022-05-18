import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart';

Future<void> create(Deck deck, Definition definition) async {
  int cardId = await api_client.post("cards", _CardSerializer(), formData: {
    "deck_id": deck.id!.toString(),
    "sys_def_id": definition.id!.toString()
  });
  await update(cardId, definition);
}

Future<void> update(int cardId, Definition definition) async =>
    await api_client.put(
      "cards/$cardId",
      api_client.DiscardResponseContentSerializer(),
      formData: Definition.toJson(definition),
    );

Future<void> delete(int cardId) {
  // TODO: implement
  throw UnimplementedError();
}

class _CardSerializer implements Serializer<int> {
  @override
  int fromJsonContentKey(content) => content["id"];
}
