import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

customAppBarWidget(ctx,
    {String buttonTitle = "", Function? onpressedFunction}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70),
    child: SafeArea(
      child: Material(
        elevation: .0,
        shadowColor: primaryWhite,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.of(ctx).push(
              //     //   MaterialPageRoute(
              //     //     builder: (BuildContext context) => HomeSplash(),
              //     //   ),
              //     // );
              //   },
              //   child: Image.asset(
              //     "assets/images/logos/52wsclogo.png",
              //     scale: 5.0,
              //   ),
              // ),
              Row(
                children: [
                  // SvgPicture.asset(
                  //   "assets/images/svgs/weather-night.svg",
                  //   semanticsLabel: "dark mode",
                  //   fit: BoxFit.cover,
                  // ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(ctx).push(
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => PhoneVerfication(),
                      //   ),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: CircleAvatar(
                        backgroundColor: primaryColour.withOpacity(.3),
                        // child: SvgPicture.asset(
                        //   "assets/images/svgs/bottomnav/account-outline.svg",
                        //   color: primaryColour,
                        //   semanticsLabel: "account",
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
