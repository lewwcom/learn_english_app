# Learn English App

## Sử dụng API

[`api_client.dart`](lib/api/api_client.dart) cài đặt sử dụng thư viện [`http`](https://pub.dev/packages/http) và dùng thư viện [`shared_preferences`](https://pub.dev/packages/shared_preferences) để lưu cookie vào bộ nhớ lưu trữ của thiết bị.

Code mẫu:

```dart
import 'package:learn_english_app/api/api_client.dart' as api_client;

Future<void> testApiClient() async {
  try {
    await api_client.post(
      "auth/signup",
      api_client.DiscardResponseContentSerializer(),
      formData: {
        "username": "test_account",
        "password": "12345678",
        "password_confirmation": "12345678",
      },
    );
  } on ApiException catch (e) {
    debugPrint(e.toString());
  }

  try {
    await api_client.post(
      "auth/login",
      api_client.DiscardResponseContentSerializer(),
      formData: {
        "username": "test_account",
        "password": "12345678",
        "remember_me": "true"
      },
    );
  } on ApiException catch (e) {
    debugPrint(e.toString());
  }

  try {
    // [WordsSerializer] implement [Serializer<List<Word>>] dùng để đọc key 
    // `content` của json object trong reponse từ dạng [dynamic] (có thể là 
    // [Map<String, dynamic>] tương ứng với json object, [List<dynamic>] hoặc 
    // [dynamic]) thành [List<Word>].
    List<Word> words =
        await api_client.get("words/?word=ca", WordsSerializer());
    debugPrint(words.first.word);
  } on ApiException catch (e) {
    debugPrint(e.toString());
  }
}
```

Cài đặt mẫu class [`WordSerializer`](lib/models/word.dart) implement interface [`Serializer<Word>`](lib/api/serializer.dart):

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
  Word fromJsonContentKey(dynamic content) {
    Word word = Word(content["word"], content["ipa"], content["audio_url"],
        content["img_url"]);

    final DefinitionSerializer definitionSerializer = DefinitionSerializer();
    word._defintions.addAll((content["sys_defs"] as List<dynamic>)
        .map((def) => definitionSerializer.fromJsonContentKey(def))
        .toList());
    return word;
  }
}
```

Khi chạy flutter, định nghĩa biến `API_BASE_URL` là đường dẫn đến server:

```bash
# AVD trỏ tới địa chỉ của host bằng 10.0.2.2
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5001/
```
