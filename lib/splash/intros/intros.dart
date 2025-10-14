import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class Intro extends StatefulWidget {
  final double? pageNumber;

  const Intro({Key? key, this.pageNumber}) : super(key: key);
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  PageController? controller;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 0,
    );
    widget.pageNumber != null ? mover() : null;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // width: 300,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.red,
                  height: MediaQuery.of(context).size.height,
                  child: PageView(
                      controller: controller,
                      children: [
                        First(),
                        Second(),
                        Third(),
                      ],
                      onPageChanged: (int index) {
                        _currentPageNotifier.value = index;
                      }),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCircleIndicator(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  mover() {
    Timer(Duration(milliseconds: 20), () {
      if (widget.pageNumber != controller?.page?.floor()) {
        controller?.animateTo(widget.pageNumber!,
            duration: Duration(seconds: 3), curve: Curves.decelerate);
      }
    });
  }

  _buildCircleIndicator() {
    return CirclePageIndicator(
      size: 10.0,
      selectedSize: 14.0,
      itemCount: 3,
      currentPageNotifier: _currentPageNotifier,
      dotColor: Colors.white,
      selectedDotColor: Colors.green,
      borderColor: Colors.yellow,
    );
  }
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
              "lib/libassets/splashimages/forest.jpg",
              fit: BoxFit.fill,
              // color: Colors.green,
              // colorBlendMode: BlendMode.color,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: 20.00,
            child: Container(
              foregroundDecoration: BoxDecoration(
                color: Colors.black,
                backgroundBlendMode: BlendMode.color,
              ),
              child: Text(
                "Use this application to register your \nfarmland for easy"
                " monitoring.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.00,
                  fontWeight: FontWeight.bold,
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
              "lib/libassets/splashimages/stump.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: 20.00,
            child: Container(
              foregroundDecoration: BoxDecoration(
                  // color: Colors.brown,
                  // backgroundBlendMode: BlendMode.color,
                  ),
              child: Text(
                "Help Keep the forest alive by actively \nparticipating in"
                " afforestation.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.00,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Third extends StatefulWidget {
  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (BuildContext context) => UserSignIn()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // margin: EdgeInsets.all(10),
            // padding: ,
            height: MediaQuery.of(context).size.height,
            // color: Colors.green,
            child: Image.asset(
              "lib/libassets/splashimages/root.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: 20.00,
            child: Container(
              foregroundDecoration: BoxDecoration(
                  // color: Colors.black,
                  // backgroundBlendMode: BlendMode.color,
                  ),
              child: Text(
                "Together, we \ncan do it",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.00,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
