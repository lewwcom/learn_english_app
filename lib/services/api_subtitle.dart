import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/models/subtitle_response.dart';

Future<SubtitleResponse> readSubtitle(String videoId) async =>
    await api_client.get("youtube?video_id=$videoId", SubtitleSerializer());
