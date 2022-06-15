import 'package:learn_english_app/api/serializer.dart';

class Avatar {
  final String content;
  Avatar(this.content);
}

class AvatarSerializer implements Serializer<Avatar> {
  @override
  Avatar fromJsonContentKey(content) {
    Avatar image = Avatar(content["avatar_url"]);
    return image;
  }
}
