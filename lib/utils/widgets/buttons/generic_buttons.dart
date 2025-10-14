import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

Widget simpleElevatedButton(
    {String buttonLabel = "", Function()? pressAction}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0.0,
      backgroundColor: primaryColour,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      textStyle: const TextStyle(color: Colors.white),
      // shadowColor: fPrimaryColour,
      side: const BorderSide(width: 1.0, color: primaryColour),
    ),
    onPressed: pressAction,
    child: Text(buttonLabel, style: const TextStyle(color: primaryWhite)),
  );
}
