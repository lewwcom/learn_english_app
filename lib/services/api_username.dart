import 'package:learn_english_app/api/api_client.dart' as api_client;

import '../models/User.dart';


Future<User> getUserName() async =>
    await api_client.get("/users/profile", NameSerializer());


Future<User> getImage() async =>
    await api_client.get("/users/profile", AvatarSerializer());