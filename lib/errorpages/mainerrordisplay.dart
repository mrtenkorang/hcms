import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';

class MainErrorDisplay extends StatefulWidget {
  final int? statusCode;
  final errorMessage;
  const MainErrorDisplay({Key? key, this.errorMessage, this.statusCode})
      : super(key: key);

  @override
  State<MainErrorDisplay> createState() => _MainErrorDisplayState();
}

class _MainErrorDisplayState extends State<MainErrorDisplay> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Image.asset("lib/libassets/widpickImages/error404.gif"),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "${widget.errorMessage}",
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            // SizedBox(
            //     width: MediaQuery.of(context).size.width * .7,
            //     child: HardButton(
            //       title: "Go Back",
            //       color: secondaryColour,
            //       textcolor: darkBackgroundColour,
            //       onPress: () async {
            //         Navigator.pop(context);
            //       },
            //     )),
          ],
        ),
      ),
    );
  }
}
