import 'package:learn_english_app/api/api_client.dart' as api_client;

import '../models/VisionRespone.dart';

class APIVision {
  Future<VisionRespone> putImage(String filepath) async {
    var reponse = await api_client.postI(
      "POST",
      "cloud-vision",
      //"http://10.0.2.2:5001/cloud-vision",
      filepath,
      VisionSerializer(),
    );
    return reponse;
  }
}
