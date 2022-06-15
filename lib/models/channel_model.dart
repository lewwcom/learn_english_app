import 'package:learn_english_app/models/video_model.dart';

class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  final String uploadPlaylistId;
  List<Video>? videos;

  Channel(
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
  );

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      map['id'],
      map['snippet']['title'],
      map['snippet']['thumbnails']['default']['url'],
      map['statistics']['subscriberCount'],
      map['statistics']['videoCount'],
      map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}
