import 'package:learn_english_app/api/serializer.dart';

class User {
  final String content;
  User(this.content);
}

class AvatarSerializer implements Serializer<User> {
  @override
  User fromJsonContentKey(content) {
    User image = User(content["avatar_url"]);
    return image;
  }
}

class NameSerializer implements Serializer<User> {
  @override
  User fromJsonContentKey(content) {
    User image = User(content["username"]);
    return image;
  }
}
