import 'package:flutter/material.dart';
import 'package:learn_english_app/api/serializer.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:http/http.dart' as http;
import 'dart:convert';

class User{
  final String content;
  User (this.content);


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


