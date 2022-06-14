import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/models/word.dart';

Future<List<Word>> readAll({String? query}) => api_client.get(
    "words${query != null ? "/?word=$query" : ""}",
    ListSerializer(WordSerializer()));

Future<Word> read(int wordId) =>
    api_client.get("words/$wordId", WordSerializer());

Future<List<Word>> readRandom(int quantity) => api_client.get(
    "words/random?quantity=$quantity", ListSerializer(WordSerializer()));
