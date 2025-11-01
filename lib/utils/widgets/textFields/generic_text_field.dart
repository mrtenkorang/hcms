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
  final bool enabled;
  final decoration; // does nothing

  const TextFieldWidget({
    super.key,
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

    this.decoration, this.enabled=true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextFormField(
        maxLength: maxLength,
        enabled: enabled,
        // maxLines: maxlines,
        obscureText: obscuretext ?? false,
        controller: controller,
        readOnly: readonly,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16, // Improved from 14 to 16 for better readability
          fontWeight: FontWeight.w400, // Added proper font weight
          color: Colors.black87, // Better text color
          height: 1.2, // Better line height
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: filled ?? false,
          fillColor: filled ?? false ? Colors.grey[50] : null, // Added fill color when filled
          labelText: labelText,
          floatingLabelStyle: const TextStyle(
            fontSize: 16, // Better size for floating label
            fontWeight: FontWeight.w500,
            color: primaryColour,
            letterSpacing: 0.5, // Slight letter spacing for elegance
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Slightly more modern radius
            borderSide: const BorderSide(
              color: Colors.grey, // Softer border color
              width: 1.5, // Consistent border width
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryRedColour,
              width: 2.0, // Thicker border on focus/error
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryColour,
              width: 2.0, // Thicker border on focus
            ),
          ),
          enabledBorder: OutlineInputBorder( // Added enabled border for better visual hierarchy
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[400]!, // Softer enabled border
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[300]!, // Lighter color for disabled state
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: errorColour,
              width: 1.5,
            ),
          ),
          errorStyle: TextStyle(
            color: errorColour,
            fontSize: 12, // Proper error text size
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0), // Better padding
            child: prefixIcon,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 24, // Better minimum constraints
            minHeight: 24,
          ),
          suffixIcon: suffixIconData != null ? GestureDetector(
            onTap: onSuffixButtonClicked,
            child: Container(
              padding: const EdgeInsets.all(8), // Better touch area
              child: Icon(
                suffixIconData,
                size: 20, // Slightly larger for better visibility
                color: readonly ? Colors.grey[400] : primaryBlackColour, // Grey out when readonly
              ),
            ),
          ) : null,
          labelStyle: const TextStyle(
            color: Colors.grey, // Better label color
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, // Better content padding
            vertical: 14,
          ),
          // Added hint style for better visual hierarchy
          hintStyle: TextStyle(
            color: Colors.grey[500], // Subtle hint color
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: onClicked,
        validator: validator,
        onChanged: onChanged,
        onEditingComplete: onSaved,
      ),
    );
  }
}