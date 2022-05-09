import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/serializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _prefs;
Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = _prefs ?? await SharedPreferences.getInstance();
}

Future<T> get<T>(String path, Serializer<T> serializer) async {
  await _init();

  _printMakingRequest("GET", path);
  final http.Response response =
      await http.get(Uri.parse(apiBaseUrl + path), headers: _makeHeader());
  _saveCookie(response);

  _printResponseCode("GET", response.statusCode);
  return serializer.fromJson(jsonDecode(response.body));
}

Future<bool> post(String path, Map<String, String> formData) async =>
    _makeMultipartRequest("post", path, formData);

Future<bool> put(String path, Map<String, String> formData) async =>
    _makeMultipartRequest("put", path, formData);

Future<bool> delete(String path) async {
  await _init();

  _printMakingRequest("DELETE", path);
  final http.Response response =
      await http.delete(Uri.parse(apiBaseUrl + path), headers: _makeHeader());
  _saveCookie(response);

  _printResponseCode("DELETE", response.statusCode);
  return _isSuccess(response);
}

Future<bool> _makeMultipartRequest(
    String method, String path, Map<String, String> formData) async {
  await _init();

  final http.MultipartRequest request =
      http.MultipartRequest(method, Uri.parse(apiBaseUrl + path));
  request.fields.addAll(formData);
  request.headers.addAll(_makeHeader());

  _printMakingRequest(method, path);
  http.StreamedResponse response = await request.send();
  _saveCookie(response);

  _printResponseCode(method, response.statusCode);
  return _isSuccess(response);
}

bool _isSuccess(http.BaseResponse response) =>
    (response.statusCode / 100).floor() == 2;

void _saveCookie(http.BaseResponse response) {
  String? cookie = response.headers["set-cookie"];
  if (cookie != null) {
    _prefs?.setString("cookie", cookie);
    debugPrint("Cookie is saved: $cookie");
  }
}

Map<String, String> _makeHeader() {
  String? cookie = _prefs?.getString("cookie");
  return cookie != null ? {"cookie": cookie} : {};
}

void _printResponseCode(String method, int responseCode) => debugPrint(
    "Response code for ${method.toUpperCase()} request: $responseCode");

void _printMakingRequest(String method, String path) =>
    debugPrint("Making ${method.toUpperCase()} request to $apiBaseUrl$path");
