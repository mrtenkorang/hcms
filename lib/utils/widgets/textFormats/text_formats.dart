import 'package:flutter/cupertino.dart';

Widget formFieldLabel(String text, {double? width}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width ?? double.infinity),
        child: Text(
          text,
          textAlign: TextAlign.start,
          softWrap: true,
          overflow: TextOverflow.clip,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
      ),
    ),
  );
}

Widget titleOne(String text, {double? fontSize}) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize ?? 24.0),
  );
}
