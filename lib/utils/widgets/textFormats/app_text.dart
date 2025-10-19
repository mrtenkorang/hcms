import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
      {super.key,
        required this.text,
        this.fontSize,
        this.fontWeight,
        this.color,
        this.textAlign});
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ??  Colors.black,
        fontFamily: "Helvetica",
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 12,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
    // style: Theme.of(context).textTheme.titleSmall!.copyWith(
    //     fontWeight: fontWeight ?? FontWeight.w400,
    //     fontSize: fontSize ?? 25,
    //     fontFamily: "Montserrat",
    //     color: color ?? const Color(0xff3ADC93)),
  }
}
