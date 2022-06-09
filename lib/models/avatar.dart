import 'package:flutter/material.dart';
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Avatar{
  final String content;
  Avatar (this.content);


}

class AvatarSerializer implements Serializer<Avatar> {
  @override
  Avatar fromJsonContentKey(content) {
    Avatar image = Avatar(content["avatar_url"]);
    return image;
  }
}
