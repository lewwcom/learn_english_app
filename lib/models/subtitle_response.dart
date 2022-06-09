import 'package:learn_english_app/api/serializer.dart';

class SubtitleResponse {
  final String content;
  final bool success;
  SubtitleResponse(this.content, this.success);
}

class SubtitleSerializer implements Serializer<SubtitleResponse> {
  @override
  SubtitleResponse fromJsonContentKey(content) {
    if (content == 'Subtitle is unavailable in this video') {
      return SubtitleResponse("", false);
    } else {
      return SubtitleResponse(content, true);
    }
  }
}
