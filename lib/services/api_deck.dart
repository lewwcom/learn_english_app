import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/deck.dart';

Future<Deck> create(String deckName) =>
    api_client.post("decks", DeckSerializer(), formData: {"name": deckName});

Future<List<Deck>> readAll() =>
    api_client.get("decks/", ListSerializer(DeckSerializer()));

Future<Deck> read(int deckId) =>
    api_client.get("decks/$deckId", DeckSerializer());

Future<void> rename(int deckId, String deckName) => api_client.put(
      "decks/$deckId",
      api_client.DiscardResponseContentSerializer(),
      formData: {"name": deckName},
    );

Future<void> delete(int deckId) => api_client.delete(
    "decks/$deckId", api_client.DiscardResponseContentSerializer());
