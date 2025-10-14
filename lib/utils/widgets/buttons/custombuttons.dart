import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

class HardButton extends StatelessWidget {
  final String title;
  final onPress, onLongPress;
  final color, textcolor, bordercolor, fontSize;
  final TextStyle? textSyle;

  const HardButton(
      {super.key,
      required this.title,
      this.onPress,
      this.onLongPress,
      this.color,
      this.textcolor,
      this.bordercolor,
      this.fontSize,
      this.textSyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        elevation: 0.0,
        shadowColor: primaryWhite,
        surfaceTintColor: color ?? primaryColour,
        foregroundColor: color ?? primaryColour,
        backgroundColor: color ?? primaryBlue,
        disabledBackgroundColor: disabledBackgroundColour,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        textStyle: textSyle ??
            TextStyle(
                color: primaryBlue, fontFamily: "Lufga", letterSpacing: 1.5),
        // shadowColor: primaryColour,
        side: BorderSide(
            width: 1.0, color: bordercolor ?? primaryWhite),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textcolor ?? primaryWhite,
          fontWeight: FontWeight.normal,
          // fontSize: fontSize ?? 16.0,
        ),
      ),
    );
  }
}

class LightButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final Color? color, fontSize;

  const LightButton(
      {super.key, required this.title, this.onPress, this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        elevation: 0.0,
        backgroundColor: color == null ? primaryWhite : primaryBlue,
        disabledBackgroundColor: disabledBackgroundColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: const TextStyle(
            color: primaryBlue, fontFamily: "Lufga", letterSpacing: 1.5),
        // shadowColor: primaryColour,
        side:
            BorderSide(width: 1.0, color: color ?? primaryBlue),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color == null ? primaryBlue : primaryWhite,
          fontWeight: FontWeight.bold,
          // fontSize: fontSize ?? 16.0,
        ),
      ),
    );
  }
}

class LoadingHardButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress, onLongPress;
  final Color? color, textcolor, bordercolor;
  final double? fontSize;
  final bool loadingTrigger;

  const LoadingHardButton({
    super.key,
    required this.title,
    this.onPress,
    this.onLongPress,
    this.color,
    this.textcolor,
    this.bordercolor,
    this.fontSize,
    this.loadingTrigger = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        elevation: 0.0,
        shadowColor: primaryWhite,
        surfaceTintColor: primaryColour,
        foregroundColor: primaryColour,
        enableFeedback: false,
        splashFactory: NoSplash.splashFactory,
        disabledMouseCursor: SystemMouseCursors.forbidden,
        // backgroundColor: color == null ? primaryColour : primaryWhiteAlt,
        backgroundColor: color ?? primaryColour,
        disabledBackgroundColor: disabledBackgroundColour,
        // disabledForegroundColor: disabledTextColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        textStyle: TextStyle(
            color: primaryColour,
            fontFamily: "Lufga",
            fontSize: fontSize ?? 14.0,
            letterSpacing: 1.5),
        // shadowColor: primaryColour,
        side: BorderSide(width: 1.0, color: bordercolor ?? Colors.transparent),
      ),
      child: loadingButtonSwitch(loadingTrigger),
    );
  }

  Widget loadingButtonSwitch(toggle) {
    Widget value = SizedBox();

    switch (toggle) {
      case true:
        value = SizedBox(
          height: 24.0,
          width: 24.0,
          child: CircularProgressIndicator(
            color: primaryWhite,
            // value: 1.0,
            strokeWidth: 2.0,
          ),
        );
        break;

      case false:
        value = Text(
          title,
          style: TextStyle(
            color: textcolor ?? primaryWhite,
            fontWeight: FontWeight.normal,
            // fontSize: fontSize ?? 16.0,
          ),
        );
        break;

      default:
        Text(
          title,
          style: TextStyle(
            color: textcolor ?? primaryWhite,
            fontWeight: FontWeight.normal,
            // fontSize: fontSize ?? 16.0,
          ),
        );
    }
    return value;
  }
}

class AddPayoutAccountHardButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress, onLongPress;
  final Color? color, textcolor, bordercolor, fontSize;
  final TextStyle? textSyle;

  const AddPayoutAccountHardButton(
      {super.key,
      required this.title,
      this.onPress,
      this.onLongPress,
      this.color,
      this.textcolor,
      this.bordercolor,
      this.fontSize,
      this.textSyle});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: onPress,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        elevation: 0.0,
        shadowColor: primaryWhite,
        surfaceTintColor: color ?? primaryColour,
        foregroundColor: color ?? primaryColour,
        backgroundColor: color ?? primaryBlue,
        disabledBackgroundColor: disabledBackgroundColour,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        textStyle: textSyle ??
            TextStyle(
                color: primaryBlue, fontFamily: "Lufga", letterSpacing: 1.0),
        // shadowColor: primaryColour,
        side: BorderSide(
            width: 1.0, color: bordercolor ?? primaryWhite),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.add_circle_outline_rounded,
              color: primaryWhite, size: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 5.5),
            child: Text(
              title,
              style: TextStyle(
                color: textcolor ?? primaryWhite,
                fontWeight: FontWeight.normal,
                // fontSize: fontSize ?? 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
