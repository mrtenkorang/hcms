import 'dart:math';
import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  static MaterialColor generateMaterialColor(String hexString) {
    return MaterialColor(fromHex(hexString).value, {
      50: tintColor(fromHex(hexString), 0.9),
      100: tintColor(fromHex(hexString), 0.8),
      200: tintColor(fromHex(hexString), 0.6),
      300: tintColor(fromHex(hexString), 0.4),
      400: tintColor(fromHex(hexString), 0.2),
      500: fromHex(hexString),
      600: shadeColor(fromHex(hexString), 0.1),
      700: shadeColor(fromHex(hexString), 0.2),
      800: shadeColor(fromHex(hexString), 0.3),
      900: shadeColor(fromHex(hexString), 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

 static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}

