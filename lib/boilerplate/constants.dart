import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const fPrimaryColour = Color(0xFF288541);
// const fPrimaryColour = Color(0xFF3f9189);
const fPrimaryWhite = Color(0xFFFFFFFF);
const fSecondaryColour = Color(0xFFffe423);
const fTextColour = Color(0xFF3C4046);
const fBackgroundColour = Color(0xFFF9F8FD);

const fred = Color(0xFFd81a60);

// ratings colour diff
const fPrimaryBlackColour = Color(0xFF000000);
const fPrimaryBronze = Color(0xFFCD7F32);
const fPrimarySilver = Color(0xFFC0C0C0);
const fPrimaryGoldColour = Color(0xFFFFD700);
const fPrimaryPlatinumColour = Color(0xFF3f9189);

const double fDefaultPadding = 20.0;

// BuildContext context;
// Size size = MediaQuery.of(context).size;

var newdate = DateTime.now();
var formatDate = DateFormat('y-MM-dd');
String formattedDate = formatDate.format(newdate);

var uuid = Uuid();

class Constants {
  static const String home = "Home";
  static const String load = "Sync data";
  static const String viewspecies = "View Species";
  static const String saveskip = "Save and Skip";
  static const String saveclose = "Save and Close";

  static const List<String> downChoices = <String>[
    home,
    load,
    saveskip,
    // saveclose,
  ];

  static const List<String> exceptiondownChoices = <String>[
    home,
    load,
  ];

  static const List<String> newdownChoices = <String>[
    home,
    load,
    viewspecies,
    saveskip,
    // saveclose,
  ];

  static const List<String> viewIncompletedownChoices = <String>[
    home,
    viewspecies,
  ];
}

class SkipConstants {
  static const String home = "Home";
  static const String saveskip = "Save and Skip";
  static const String saveclose = "Save and Close";

  static const List<String> downChoices = <String>[
    home,
    saveskip,
    // saveclose,
  ];
}


class MaxLocationAccuracy {
  static double max = 4.0;
}