import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/home/auth/register/register.dart';
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:hcms_revived2/screens/home/index.dart';

class AuthHome extends StatefulWidget {
  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // margin: EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height,
            // color: Color(0xFFf7f7f7),
            padding: const EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Image.asset(
                "lib/libassets/uxImages/home_tree.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black54,
                backgroundBlendMode: BlendMode.colorBurn),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(30),
                    // height: MediaQuery.of(context).size.height,
                    // color: Color(0xFFf7f7f7),
                    padding: const EdgeInsets.all(0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        "lib/libassets/logos/hcmslogo.png",
                        height: MediaQuery.of(context).size.height * .3,
                        width: MediaQuery.of(context).size.width * .5,
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        "Hybrid Community-Based Monitoring System (HCMS)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fPrimaryWhite,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // Container(
                  //   width: MediaQuery.of(context).size.width * .8,
                  //   child: GettingStartedButton(
                  //     title: "Create an account",
                  //     onPress: () {
                  //       Navigator.of(context).push(
                  //         CupertinoPageRoute(
                  //           builder: (context) => Register(),
                  //         ),
                  //       );
                  //     },
                  //     color: fPrimaryColour,
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: HardButton(
                      title: "Sign in",
                      onPress: () {
                        // Navigator.of(context).push(
                        //   CupertinoPageRoute(
                        //     builder: (context) => IndexPage(
                        //       userContact: "027567890",
                        //     ),
                        //   ),
                        // );
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => UserSignIn(),
                          ),
                        );
                      },
                      color: fPrimaryWhite,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
