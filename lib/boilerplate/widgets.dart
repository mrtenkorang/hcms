// import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/helpers/dbhelper.dart';
import 'package:hcms_revived2/main.dart';
import 'package:overlay_support/overlay_support.dart';

class GenderRadioButton extends StatelessWidget {
  final int? value;
  final int? group;
  final selected;

  const GenderRadioButton({
    Key? key,
    this.value,
    this.group,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      key: key,
      value: value,
      groupValue: group,
      activeColor: fPrimaryColour,
      onChanged: selected,
    );
  }
}

class EstablishmentRadioButton extends StatelessWidget {
  final int? value;
  final int? group;
  final selected;

  const EstablishmentRadioButton({
    Key? key,
    this.value,
    this.group,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      key: key,
      value: value,
      groupValue: group,
      activeColor: Color(0xFFfc1d20),
      onChanged: selected,
    );
  }
}

// class Alert {
//   static final List<Flushbar>? flushBars = [];

//   static void showSnackBar(
//     BuildContext context, {
//     required String text,
//     required Color color,
//     Duration? duration,
//   }) =>
//       _show(
//         context,
//         Flushbar(
//           isDismissible: true,
//           routeColor: Colors.red,
//           messageText: Center(
//               child: Text(
//             text,
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           )),
//           duration: duration == null ? Duration(seconds: 5) : duration,
//           flushbarPosition: FlushbarPosition.BOTTOM,
//           backgroundColor: color,
//           animationDuration: Duration(microseconds: 0),
//         ),
//       );

//   static Future _show(BuildContext context, Flushbar newFlushBar) async {
//     await Future.wait(
//         flushBars!.map((flushBar) => flushBar.dismiss()).toList());
//     flushBars?.clear();

//     newFlushBar.show(context);
//     flushBars?.add(newFlushBar);
//   }
// }

void overlayNotification(message, String status, {position}) {
  showSimpleNotification(Text(message.toString()),
      leading: const Icon(
        Icons.error_outline_outlined,
        color: fPrimaryWhite,
      ),
      position: position ?? NotificationPosition.bottom,
      duration: const Duration(seconds: 5),
      background: status == "positive" ? fPrimaryColour : Colors.red.shade700);
}

void popUpDialogue(context, text2, {imageIcon}) {
  showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "success alert",
      barrierColor: Colors.black26,
      context: context,
      pageBuilder: (BuildContext context, animation, newanimation) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Material(
              child: Container(
                // width: 5000,
                // height: 100,
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border(
                        bottom: BorderSide(color: fPrimaryColour),
                        left: BorderSide(color: fPrimaryColour),
                        right: BorderSide(color: fPrimaryColour),
                        top: BorderSide(color: fPrimaryColour)),
                    color: fPrimaryWhite),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        child: Text(
                          text2,
                          style: TextStyle(
                              // fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: fPrimaryColour),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        child: Container(
                            child: imageIcon ??
                                Icon(
                                  Icons.verified_rounded,
                                  size: 50.0,
                                  color: fPrimaryColour,
                                )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

void submissionOptions(
  BuildContext context,
  title,
  heading1,
  heading2,
  heading3, {
  required approvePress(),
  required editPress(),
  required disapprovePress(),
  String? userRate = "",
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            // width: 5000,
            child: userRate!.isEmpty
                ? AlertDialog(
                    title: new Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    actions: [
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            approvePress();
                          },
                          child: Text(
                            heading1,
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      heading2.toString().isNotEmpty
                          ? Center(
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  editPress();
                                },
                                child: Text(heading2),
                              ),
                            )
                          : SizedBox(),
                      heading3.toString().isNotEmpty
                          ? Center(
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  disapprovePress();
                                },
                                child: Text(heading3),
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                : AlertDialog(
                    title: Container(
                      // decoration: BoxDecoration(color: fPrimaryColour),
                      child: new Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: fPrimaryColour),
                      ),
                    ),
                    content: heading2,
                    actions: [
                      TextButton(
                        onPressed: () async {
                          regSP?.setBool("ratinginitrun", true);
                          Navigator.pop(context);
                          approvePress();
                        },
                        child: Text(
                          heading1,
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      });
}

void submissionLoader(context, text1, text2) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            // width: 5000,
            child: AlertDialog(
              title: new Text(
                text1,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF006633),
                    ),
                  ),
                  new Text(
                    text2,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void userRatingDialogue(context, treeCount) {
  return int.parse(treeCount!) >= 0 && int.parse(treeCount!) < 100
      ? submissionOptions(
          context,
          "Oopsie ☹",
          "Noted!!",
          RichText(
            text: new TextSpan(style: TextStyle(color: fTextColour), children: [
              TextSpan(
                text: "As you"
                    " register more planted trees, you will notice a"
                    " change on the badge at the top right. Click on it to see progress"
                    " Your next checkpoint is to register ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: "100 trees.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " Let's do this! ",
              ),
            ]),
          ),
          "",
          approvePress: () {},
          editPress: () {},
          disapprovePress: () {},
          userRate: "yes")
      : int.parse(treeCount!) >= 100 && int.parse(treeCount!) < 200
          ? submissionOptions(
              context,
              "Great work",
              "Yayy 🎉!!",
              RichText(
                text: new TextSpan(
                    style: TextStyle(color: fTextColour),
                    children: [
                      TextSpan(
                        text: "You are doing great! You have registered ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "$treeCount trees. ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "Next is to register ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "200 trees.",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: " We can do this! ",
                      ),
                    ]),
              ),
              "",
              approvePress: () {},
              editPress: () {},
              disapprovePress: () {},
              userRate: "yes")
          : int.parse(treeCount!) >= 200 && int.parse(treeCount!) < 500
              ? submissionOptions(
                  context,
                  "You are on fire 🥉",
                  "More fire!!",
                  RichText(
                    text: new TextSpan(
                        style: TextStyle(color: fTextColour),
                        children: [
                          TextSpan(
                            text: "We have now registered up to ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: "$treeCount trees. ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "Hopefully you're not giving up now. Let's keep up with the good work. ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ]),
                  ),
                  "",
                  approvePress: () {},
                  editPress: () {},
                  disapprovePress: () {},
                  userRate: "yes")
              : int.parse(treeCount!) >= 500 && int.parse(treeCount!) < 1000
                  ? submissionOptions(
                      context,
                      "You deserve an award 🥇",
                      "Yayy 🎉!!",
                      RichText(
                        text: new TextSpan(
                            style: TextStyle(color: fTextColour),
                            children: [
                              TextSpan(
                                text: "You have registered ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: "$treeCount",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " naturally occuring trees now. "
                                    "Your hardwork is visible to all. We can reach a thousand trees soon."
                                    " Please keep up the good work!",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                      "",
                      approvePress: () {},
                      editPress: () {},
                      disapprovePress: () {},
                      userRate: "yes")
                  : submissionOptions(
                      context,
                      "Ultimate 🥇🏆",
                      "Great 🎉!!",
                      RichText(
                        text: new TextSpan(
                            style: TextStyle(color: fTextColour),
                            children: [
                              TextSpan(
                                text: "You have reached senior levels! ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: "$treeCount trees!! 🍾 ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    " You have done very great and we will not forget. Thank you and keep up the great work.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                      "",
                      approvePress: () {},
                      editPress: () {},
                      disapprovePress: () {},
                      userRate: "yes");
}

class BoilerTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? initialVal;
  final IconData? suffixIconData;
  final onChanged;
  final onSaved;
  final onClicked;
  final validator;
  final onEditingComplete;
  final onSubmitted;
  final TextInputType? type;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final bool readonly;
  final int? maxlength;

  const BoilerTextFieldWidget({
    Key? key,
    this.labelText,
    this.hintText,
    this.initialVal,
    this.suffixIconData,
    this.onChanged,
    this.onSaved,
    this.onClicked,
    this.validator,
    this.onEditingComplete,
    this.onSubmitted,
    this.type,
    this.labelStyle,
    this.controller,
    this.readonly = false,
    this.maxlength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onSubmitted,
        maxLength: maxlength,
        readOnly: readonly == false ? readonly : true,
        controller: controller,
        initialValue: initialVal,
        keyboardType: type,
        onSaved: onSaved,
        onChanged: onChanged,
        style: TextStyle(
          color: Color(0xFFfc1d20),
          fontSize: 14,
        ),
        decoration: InputDecoration(
            // filled: true,
            labelText: labelText,
            hintText: hintText,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color(0xFFfc1d20),
              ),
            ),
            suffixIcon: GestureDetector(
              // onTap: () {
              //   // model.isVisible = !model.isVisible;
              //   _submissionLoading(context);
              // },
              onTap: onClicked,
              child: Icon(
                suffixIconData,
                size: 18,
                color: Color(0xFFfc1d20),
              ),
            ),
            labelStyle: labelStyle,
            focusColor: Color(0xFFfc1d20)),
        onTap: onClicked,
        validator: validator,
      ),
    );
  }

  void _submissionLoading(BuildContext context) {
    final k = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Container(
              // width: 5000,
              child: AlertDialog(
                title: new Text(
                  "Please type in new value",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                content: BoilerTextFieldWidget(
                  controller: k,
                  readonly: false,
                  labelText: this.labelText,
                  hintText: "Type here",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      print("Done ${this.hintText}");
                      // DBHelper.update(k.text, this.hintText);
                      this.controller?.text = k.text;
                      Navigator.pop(context);
                    },
                    child: Text("Edit"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class NewBoilerTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? initialVal;
  final IconData? suffixIconData;
  final onChanged;
  final onSaved;
  final onClicked;
  final validator;
  final onEditingComplete;
  final onSubmitted;
  final TextInputType? type;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final bool readonly;
  final int? maxlength;

  const NewBoilerTextFieldWidget({
    Key? key,
    this.labelText,
    this.hintText,
    this.initialVal,
    this.suffixIconData,
    this.onChanged,
    this.onSaved,
    this.onClicked,
    this.validator,
    this.onEditingComplete,
    this.onSubmitted,
    this.type,
    this.labelStyle,
    this.controller,
    this.readonly = false,
    this.maxlength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextFormField(
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onSubmitted,
        maxLength: maxlength,
        readOnly: readonly == false ? readonly : true,
        controller: controller,
        initialValue: initialVal,
        keyboardType: type,
        onSaved: onSaved,
        onChanged: onChanged,
        style: TextStyle(
          // color: Color(0xFFfc1d20),
          fontSize: 14,
        ),
        decoration: InputDecoration(
            // filled: true,
            labelText: labelText,
            hintText: hintText,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color(0xFFfc1d20),
              ),
            ),
            suffixIcon: GestureDetector(
              // onTap: () {
              //   // model.isVisible = !model.isVisible;
              //   _submissionLoading(context);
              // },
              onTap: onClicked,
              child: Icon(
                suffixIconData,
                size: 18,
                color: Color(0xFFfc1d20),
              ),
            ),
            labelStyle: labelStyle,
            focusColor: Color(0xFFfc1d20)),
        onTap: onClicked,
        validator: validator,
      ),
    );
  }
}

class HardButton extends StatelessWidget {
  final String title;
  final onPress;
  final color;

  const HardButton({
    Key? key,
    required this.title,
    this.onPress,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
          color: color == null ? fPrimaryWhite : fPrimaryColour,
          // color: primaryWhite,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          // letterSpacing: 2.0,
          // wordSpacing: 2.0,
        ),
      ),
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        elevation: 0.0,
        backgroundColor: color == null ? fPrimaryColour : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: const TextStyle(color: fPrimaryColour),
        // shadowColor: fPrimaryColour,
        side: BorderSide(
            width: 1.0, color: color == null ? fPrimaryWhite : color),
      ),
    );
  }
}

class LightButton extends StatelessWidget {
  final String title;
  final onPress;
  final color;

  const LightButton({
    Key? key,
    required this.title,
    this.onPress,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
            color: color == null ? fPrimaryColour : fPrimaryWhite,
            fontWeight: FontWeight.bold,
            fontSize: 16.0),
      ),
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        elevation: 0.0,
        backgroundColor: color == null ? fPrimaryWhite : fPrimaryColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: const TextStyle(color: fPrimaryColour),
        // shadowColor: fPrimaryColour,
        side: BorderSide(
            width: 1.0, color: color == null ? fPrimaryColour : color),
      ),
    );
  }
}

class GettingStartedButton extends StatelessWidget {
  final String title;
  final onPress;
  final color;

  const GettingStartedButton({
    Key? key,
    required this.title,
    this.onPress,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
          color: fPrimaryWhite,
          // color: primaryWhite,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          // letterSpacing: 2.0,
          // wordSpacing: 2.0,
        ),
      ),
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        elevation: 0.0,
        backgroundColor: color == null ? fPrimaryColour : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: const TextStyle(color: fPrimaryColour),
        // shadowColor: fPrimaryColour,
        side: BorderSide(
            width: 1.0, color: color == null ? fPrimaryWhite : color),
      ),
    );
  }
}
