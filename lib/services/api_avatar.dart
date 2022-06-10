import 'package:learn_english_app/api/api_client.dart' as api_client;

import '../models/avatar.dart';


Future<Avatar> getImage() async =>
    await api_client.get("/users/profile", AvatarSerializer());