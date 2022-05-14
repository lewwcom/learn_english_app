import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

const _buttonPadding =
    EdgeInsets.symmetric(vertical: kPadding / 2, horizontal: kPadding);

final ThemeData themeData = ThemeData(
  colorScheme: const ColorScheme.light(),
  cardTheme: CardTheme(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kRadius),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      padding: _buttonPadding,
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const StadiumBorder(),
      padding: _buttonPadding,
    ),
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kRadius),
    ),
    titleTextStyle: Typography.material2018()
        .geometryThemeFor(ScriptCategory.englishLike)
        .titleLarge
        ?.copyWith(color: const ColorScheme.light().primary),
  ),
);
