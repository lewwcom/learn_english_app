# Learn English App

## Sử dụng API

Code mẫu:

```dart
import 'package:learn_english_app/api/api_client.dart' as api_client;

Future<void> testApiClient() async {
  await api_client.post(
    "auth/signup",
    // POST request sử dụng form-data
    {
      "username": "test_account",
      "password": "12345678",
      "password_confirmation": "12345678",
    },
  );
  await api_client.post(
    "auth/login",
    {"username": "test_account", "password": "12345678", "remember_me": "true"},
  );

  // [WordsSerializer] implement [Serializer<List<Word>>] dùng để đọc json dạng
  // [Map<String, dynamic>] thành List<Word>
  List<Word> words = await api_client.get("words/?word=ca", WordsSerializer());
  debugPrint(words.first.word);
}
```

Cài đặt mẫu class [`WordSerializer`](lib/models/word.dart) implement interface [`Serializer<Word>`](lib/models/serializer.dart):

```dart
class Word {
  final String word;
  final String ipa;
  final String? audioUrl;
  final String? imgUrl;
  final List<Definition> _defintions = List.empty(growable: true);

  Word(this.word, this.ipa, this.audioUrl, this.imgUrl);
}

class WordSerializer implements Serializer<Word> {
  @override
  Word fromJson(Map<String, dynamic> json) {
    Word word =
        Word(json["word"], json["ipa"], json["audio_url"], json["img_url"]);

    final DefinitionSerializer definitionSerializer = DefinitionSerializer();
    word._defintions.addAll((json["sys_defs"] as List<dynamic>)
        .map((def) => definitionSerializer.fromJson(def))
        .toList());
    return word;
  }
}
```

Chạy flutter:

```bash
flutter run --dart-define=API_BASE_URL=http://<server-url>/
```
