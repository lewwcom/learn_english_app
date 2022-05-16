import 'package:flutter/material.dart';
const double kPadding = 20;
const double kRadius = 10;

/// Pass [playerId] to [AudioPlayer] constructor to use the same instance that was created before.
const String kAudioPlayerId = "audioplayerid";

const String apiBaseUrl = String.fromEnvironment("API_BASE_URL");

const kPrimaryColor = Color(0xFF00B0FF);
const kPrimaryColor2= Color(0xFFE3F2FD);
const kTextColor = Color(0xFF202E2E);
const kTextLigntColor = Color(0xFF7286A5);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
const kTitleTextColor = Color(0xFF303030);

const kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

