import 'package:flutter/material.dart' hide DatePickerTheme;

class MiddleSectionTitle extends StatelessWidget {
  const MiddleSectionTitle({
    Key? key,
    this.text = "",
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.00),
          child: Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
