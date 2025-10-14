import 'package:flutter/material.dart';
import 'package:hcms_revived2/utils/constants/colours.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final Widget? prefixIcon;
  final suffixIconData;
  final onChanged;
  final onSaved;
  final onClicked;
  final void Function()? onSuffixButtonClicked;
  final String? Function(String?)? validator;
  final validatorVal;
  final onSubmitted;
  final TextInputType keyboardType;
  final TextStyle labelStyle;
  final TextStyle? floatingLabelStyle;
  final TextEditingController controller;
  final maxLength;
  final maxlines;
  final filled;
  final obscuretext;
  final bool readonly;

  final decoration; // does nothing

  const TextFieldWidget({
    this.labelText = "",
    this.prefixIcon,
    this.suffixIconData,
    this.onChanged,
    this.onSaved,
    this.onClicked,
    this.onSuffixButtonClicked,
    this.validator,
    this.validatorVal,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.labelStyle = const TextStyle(),
    this.floatingLabelStyle,
    required this.controller,
    this.maxLength,
    this.maxlines,
    this.filled,
    this.obscuretext,
    this.readonly = false,

    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextFormField(
        maxLength: maxLength,
        // maxLines: maxlines,
        obscureText: obscuretext ?? false,
        controller: controller,
        readOnly: readonly,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: filled ?? false,
          labelText: labelText,
          floatingLabelStyle:
              const TextStyle(fontSize: 20.0, color: primaryColour),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryBlackColour),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: primaryRedColour,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: primaryColour,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryBlackColour),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(5),
          //   borderSide: BorderSide(color: primaryYellow),
          // ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: errorColour,
            ),
          ),
          errorStyle: TextStyle(color: errorColour),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: prefixIcon,
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: GestureDetector(
            onTap: onSuffixButtonClicked,
            child: Icon(
              suffixIconData,
              size: 18,
              color: primaryBlackColour,
            ),
          ),
          labelStyle: const TextStyle(color: primaryBlackColour),
        ),
        onTap: onClicked,
        validator: validator,
        onChanged: onChanged,
        onEditingComplete: onSaved,
      ),
    );
  }
}
