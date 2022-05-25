import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/api/serializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Handle 401 Unauthorized

//==============================================================================
// GET, POST, PUT, DELETE
//==============================================================================

/// Use [DiscardResponseContentSerializer] if you don't want to receive object
/// from reponse.
Future<T> get<T>(String path, Serializer<T> serializer) async =>
    _request(http.get, "get", path, serializer);

/// Use [DiscardResponseContentSerializer] if you don't want to receive object
/// from reponse.
Future<T> post<T>(String path, Serializer<T> serializer,
        {Map<String, String>? formData}) async =>
    formData != null
        ? _makeMultipartRequest("post", path, formData, serializer)
        : _request(http.post, "post", path, serializer);

/// Use [DiscardResponseContentSerializer] if you don't want to receive object
/// from reponse.
Future<T> put<T>(String path, Serializer<T> serializer,
        {Map<String, String>? formData}) async =>
    formData != null
        ? _makeMultipartRequest("put", path, formData, serializer)
        : _request(http.put, "put", path, serializer);

/// Use [DiscardResponseContentSerializer] if you don't want to receive object
/// from reponse.
Future<T> delete<T>(String path, Serializer<T> serializer) async =>
    _request(http.delete, "delete", path, serializer);

//==============================================================================
// Private functions
//==============================================================================

typedef _RequestMethod = Future<http.Response> Function(Uri url,
    {Map<String, String>? headers});

Future<T> _request<T>(_RequestMethod request, String methodName, String path,
    Serializer<T> serializer) async {
  await _init();

  _printMakingRequest(methodName, path);
  final http.Response response =
      await request(Uri.parse(kApiBaseUrl + path), headers: _makeHeader());
  _saveCookie(response);
  _printResponseCode(methodName, response.statusCode);

  return serializer.fromJsonContentKey(_jsonContentFromResponse(response));
}

Future<T> _makeMultipartRequest<T>(String method, String path,
    Map<String, String> formData, Serializer<T> serializer) async {
  await _init();

  final http.MultipartRequest request =
      http.MultipartRequest(method, Uri.parse(kApiBaseUrl + path));
  request.fields.addAll(formData);
  request.headers.addAll(_makeHeader());

  _printMakingRequest(method, path);
  http.StreamedResponse response = await request.send();
  _saveCookie(response);
  _printResponseCode(method, response.statusCode);

  return serializer.fromJsonContentKey(
      _jsonContentFromResponse(await http.Response.fromStream(response)));
}

/// If response is json, it will look like:
/// ```json
/// {
///   "content": "content-value",
///   "success": "true"
/// }
/// ```
/// Return value of `content` key of json object. Throw [ApiException] if
/// `success` key is `false` or content-type of response is not application/json.
dynamic _jsonContentFromResponse(http.Response response) {
  String? contentType = response.headers["content-type"];

  // Content type is not application/json meaning this response is auto-generated.
  if (contentType == null || !contentType.contains("application/json")) {
    throw ApiException.fromJsonContentKey("Failed to load response data.");
  }

  final Map<String, dynamic> json = jsonDecode(response.body);
  if (!json["success"]) {
    throw ApiException.fromJsonContentKey(json["content"]);
  }

  return json["content"];
}

//==============================================================================
// Cookie
//==============================================================================

SharedPreferences? _prefs;
Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = _prefs ?? await SharedPreferences.getInstance();
}

Future<void> removeCookie() async {
  await _init();
  _prefs?.remove("cookie");
}

void _saveCookie(http.BaseResponse response) {
  String? cookie = response.headers["set-cookie"];
  String? existedCookie = _prefs?.getString("cookie");
  if (cookie != null &&
      (existedCookie == null || !existedCookie.startsWith("remember_token"))) {
    _prefs?.setString("cookie", cookie);
    debugPrint("Cookie is saved: $cookie");
  }
}

Map<String, String> _makeHeader() {
  String? cookie = _prefs?.getString("cookie");
  return cookie != null ? {"cookie": cookie} : {};
}

//==============================================================================
// Helpers
//==============================================================================

/// [formJsonContentKey] always returns true.
class DiscardResponseContentSerializer implements Serializer<bool> {
  /// Always return true.
  @override
  bool fromJsonContentKey(json) => true;
}

void _printResponseCode(String method, int responseCode) => debugPrint(
    "Response code for ${method.toUpperCase()} request: $responseCode");

void _printMakingRequest(String method, String path) =>
    debugPrint("Making ${method.toUpperCase()} request to $kApiBaseUrl$path");
