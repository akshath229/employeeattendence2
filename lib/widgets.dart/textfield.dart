import 'package:flutter/material.dart';
import 'package:geotest/const/Colours.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText; 
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.hintText = '',
    this.labelText, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      cursorColor: AllColours.primaryColour,
      style: GoogleFonts.poppins(),
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: AllColours.primaryColour),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: AllColours.primaryColour),
        focusColor: AllColours.primaryColour,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AllColours.primaryColour,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AllColours.primaryColour,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: validator,
    );
  }
}
