import 'package:flutter/material.dart';

const double kPadding = 20;
const double kRadius = 10;
const double kSmallIconSize = 16;

/// Pass [playerId] to [AudioPlayer] constructor to use the same instance that was created before.
const String kAudioPlayerId = "audioplayerid";

const String kApiBaseUrl = String.fromEnvironment("API_BASE_URL");
//const String kApiBaseUrl = "http://10.0.2.2:5001";

const kPrimaryColor = Color(0xFF00B0FF);
const kPrimaryColor2 = Color(0xFFE3F2FD);
const kTextColor = Color(0xFF202E2E);
const kTextLigntColor = Color(0xFF7286A5);
final kShadowColor = const Color(0xFFB7B7B7).withOpacity(.16);
const kTitleTextColor = Color(0xFF303030);
const kBlackColor = Color(0xFF101010);
const kGreenColor = Color(0xFF6AC259);
const kRedColor = Color(0xFFE92E30);
const kGrayColor = Color(0xFFC1C1C1);
const kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);


const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
const kScreenTitleTextstyle = TextStyle(
  fontSize: 23,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

const kTextstyle = TextStyle(
  fontSize: 14,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);


const kUserstyle = TextStyle(
  fontSize: 28,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);