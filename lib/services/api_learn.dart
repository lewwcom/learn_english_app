import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/deck.dart';

Future<List<Deck>> readLearnAll() async =>
    await api_client.get("decks/", ListSerializer(DeckSerializer()));

Future<Deck> readLearn(int deckId) async =>
    await api_client.get("decks/$deckId?card-type=due", DeckSerializer());

updateLearnCard(int? cardId, int quality) async {
  await api_client.put(
      "cards/$cardId/revise", api_client.DiscardResponseContentSerializer(),
      formData: {"quality": quality.toString()});
}
