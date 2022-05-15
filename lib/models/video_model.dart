class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video(
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  );

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
      snippet['resourceId']['videoId'],
      snippet['title'],
      snippet['thumbnails']['high']['url'],
      snippet['channelTitle'],
    );
  }

  factory Video.fromMapSearch(
      Map<String, dynamic> snippet, Map<String, dynamic> id) {
    return Video(
      id['videoId'],
      snippet['title'],
      snippet['thumbnails']['high']['url'],
      snippet['channelTitle'],
    );
  }
}
