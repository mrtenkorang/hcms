import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:hcms_revived2/boilerplate/constants.dart';

class ViewCard extends StatefulWidget {
  final String? name;
  final String? timeSent;
  final String? email;
  final String? community;
  final String? image;
  final String? type;
  final String? dateRecorded;
  final pressAction;
  final Color? color;
  final String? conState;

  const ViewCard(
      {Key? key,
      this.name,
      this.timeSent,
      this.email,
      this.community,
      this.image,
      this.type,
      this.dateRecorded,
      this.pressAction,
      this.color,
      this.conState})
      : super(key: key);

  @override
  _ViewCardState createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {
  final double _borderRadius = 24;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                gradient: widget.type == "Individual"
                    ? LinearGradient(
                        colors: [fPrimaryColour, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)
                    : LinearGradient(
                        colors: [Color(0xff42E695), Color(0xff3BB2B8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: Size(50, 150),
                painter: widget.conState == "incomplete"
                    ? CustomCardShapePainter(
                        _borderRadius, Colors.grey, Colors.grey)
                    : widget.type == "Individual"
                        ? CustomCardShapePainter(
                            _borderRadius, Colors.orange, Colors.yellow)
                        : CustomCardShapePainter(
                            _borderRadius, Colors.red, Colors.yellow),
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: widget.type == "Group"
                        ? CircleAvatar(
                            radius: 20,
                            child: Text("G"),
                          )
                        : widget.image!.isNotEmpty
                            ? CircleAvatar(
                                radius: 30.0,
                                child: Image.memory(
                                  base64.decode(widget.image!),
                                  // repeat: ImageRepeat.repeat,
                                  height: 64,
                                  width: 64,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : CircleAvatar(
                                radius: 30.0,
                                child: Image.asset(
                                  "lib/libassets/images/newUser.png",
                                  // repeat: ImageRepeat.repeat,
                                  height: 64,
                                  width: 64,
                                  fit: BoxFit.contain,
                                ),
                              ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "Date: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.dateRecorded ?? "",
                                style: TextStyle(
                                    color: fPrimaryBlackColour,
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.conState == "incomplete"
                                ? "Incomplete submission"
                                : "${widget.type} submission",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          widget.name ?? "name",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.email ?? "email",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            widget.conState == "incomplete"
                                ? Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                    size: 25,
                                  )
                                : widget.color == null
                                    ? Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Icon(
                                        Icons.warning,
                                        color: widget.color,
                                        size: 16,
                                      ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                widget.timeSent ?? "time sent",
                                style: TextStyle(
                                  color: widget.color == null
                                      ? Colors.white
                                      : widget.color,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: widget.pressAction,
                          icon: widget.conState == "connected"
                              ? Icon(
                                  Icons.more_vert,
                                  size: 30.0,
                                  color: fPrimaryColour,
                                )
                              : Icon(
                                  Icons.edit,
                                  size: 35.0,
                                  color: fPrimaryColour,
                                ),
                          // child: Text("Next")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
