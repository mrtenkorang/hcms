import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:hcms_revived2/boilerplate/constants.dart';
import 'package:hcms_revived2/boilerplate/widgets.dart';
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:hcms_revived2/splash/intros/authhome.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewIntros extends StatefulWidget {
  final double? pageNumber;

  const NewIntros({Key? key, this.pageNumber}) : super(key: key);
  @override
  _NewIntrosState createState() => _NewIntrosState();
}

class _NewIntrosState extends State<NewIntros> {
  // PageController? controller;
  // final _currentPageNotifier = ValueNotifier<int>(0);
  int currentIndex = 0;

  final controller = PageController(keepPage: true);

  List<Widget> screens = [
    First(),
    Second(),
    // Third(),
  ];

  @override
  void initState() {
    super.initState();
    // controller = PageController(
    //   initialPage: 0,
    // );
    // widget.pageNumber != null ? mover() : null;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // width: 300,
        child: Stack(
          children: [
            Container(
              color: Colors.red,
              // height: MediaQuery.of(context).size.height,
              child: PageView(
                  controller: controller,
                  children: screens,
                  onPageChanged: (int index) {
                    setState(() {
                      // _currentPageNotifier.value = index;
                      currentIndex = index;
                    });
                  }),
            ),
            // Transform.translate(
            //   offset: Offset(0, 600),
            //   child: PageViewIndicator(
            //     length: screens.length,
            //     currentIndex: currentIndex,
            //     otherSize: 3,
            //   ),
            // ),
            // SmoothPageIndicator(
            //   controller: controller,
            //   count: screens.length,
            //   effect: ExpandingDotsEffect(
            //     dotHeight: 16,
            //     dotWidth: 16,
            //     // jumpScale: .7,
            //     // verticalOffset: 15,
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     color: Color(0xFF2F5517),
            //     height: screenSize.height * .3,
            //   ),
            // ),
            // ClipPath(
            //     clipper: CustomClipPath(),
            //     child: Container(
            //       color: Colors.white12,
            //       height: screenSize.height * .8,
            //     )),
            Positioned(
              bottom: MediaQuery.of(context).size.height * .035,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    currentIndex == 0
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          AuthHome()));
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: fPrimaryWhite,
                                  fontWeight: FontWeight.bold),
                            ))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                slidePage(0);
                              });
                            },
                            child: Text(
                              "Prev",
                              style: TextStyle(
                                  color: fPrimaryWhite,
                                  fontWeight: FontWeight.bold),
                            )),
                    SmoothPageIndicator(
                      controller: controller,
                      count: screens.length,
                      effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8.5,
                          activeDotColor: fPrimaryWhite,
                          dotColor: fPrimaryWhite
                          // jumpScale: .7,
                          // verticalOffset: 15,
                          ),
                    ),
                    currentIndex == 0
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                // currentIndex = 1;
                                // screens[currentIndex];
                                slidePage(1);
                              });
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  color: fPrimaryWhite,
                                  fontWeight: FontWeight.bold),
                            ))
                        : GettingStartedButton(
                            title: "Get Started",
                            onPress: () {
                              Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          AuthHome()));
                            },
                            color: fPrimaryColour,
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // mover() {
  //   Timer(Duration(milliseconds: 20), () {
  //     if (widget.pageNumber != controller?.page?.floor()) {
  //       controller?.animateTo(widget.pageNumber!,
  //           duration: Duration(seconds: 3), curve: Curves.decelerate);
  //     }
  //   });
  // }

  slidePage(int pageIndex) {
    controller.animateToPage(pageIndex,
        duration: Duration(milliseconds: 120), curve: Curves.slowMiddle);
  }

  // _buildCircleIndicator() {
  //   return CirclePageIndicator(
  //     size: 10.0,
  //     selectedSize: 14.0,
  //     itemCount: 3,
  //     // currentPageNotifier: _currentPageNotifier,
  //     dotColor: Colors.white,
  //     selectedDotColor: Colors.green,
  //     borderColor: Colors.yellow,
  //   );
  // }
}

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            // color: Colors.green,
            child: Image.asset(
              "lib/libassets/uxImages/splashleaves.jpg",
              fit: BoxFit.cover,
              // color: Colors.green,
              // colorBlendMode: BlendMode.color,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black26,
                backgroundBlendMode: BlendMode.colorBurn),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .1,
            // left: 20.00,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                // foregroundDecoration: BoxDecoration(
                //   color: Colors.black,
                //   backgroundBlendMode: BlendMode.color,
                // ),
                child: Text(
                  "Help keep the forest alive by actively participating in afforestation",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.00,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            // color: Colors.green,
            child: Image.asset(
              "lib/libassets/uxImages/splashfarmer.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .1,
            // left: 20.00,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                // foregroundDecoration: BoxDecoration(
                //   color: Colors.black,
                //   backgroundBlendMode: BlendMode.color,
                // ),
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.00,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
