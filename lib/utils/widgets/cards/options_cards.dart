import 'package:flutter/material.dart';

class OptionsCard extends StatelessWidget {
  final String? title, description;
  final pressHandler;
  final Icon? icon;
  final Color? color, titleColor, descriptionColor;
  final borderColor;

  const OptionsCard(
      {Key? key,
      this.title,
      this.description,
      this.pressHandler,
      this.icon,
      this.color,
      this.titleColor,
      this.descriptionColor,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // height: size.height * .21,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border(
            top: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            bottom: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            left: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
            right: BorderSide(
                color: borderColor != null ? borderColor : Colors.black12),
          ),
          // color: fSecondaryColour,
          color: color,
        ),
        child: ListTile(
          leading: icon,
          title: Text(title ?? "Title",
              style: TextStyle(color: titleColor != null ? titleColor : null)),
          subtitle: Text(description ?? "Description",
              style: TextStyle(
                  color: descriptionColor != null ? descriptionColor : null)),
          onTap: pressHandler,
        ),
      ),
    );
  }
}
