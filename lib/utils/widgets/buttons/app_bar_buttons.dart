import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

Widget appBarBackButton(context) {
  return Material(
    elevation: 8.0,
    borderRadius: const BorderRadius.all(
      Radius.circular(12.0),
    ),
    color: Colors.white30,
    child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: primaryWhite,
          size: 40.0,
        )),
  );
}

Widget appBarForwardButton(Function() pressAction) {
  return Material(
    elevation: 8.0,
    borderRadius: const BorderRadius.all(
      Radius.circular(12.0),
    ),
    color: Colors.white30,
    child: IconButton(
        onPressed: pressAction,
        icon: const Icon(
          Icons.arrow_forward,
          color: primaryWhite,
          size: 40.0,
        )),
  );
}
