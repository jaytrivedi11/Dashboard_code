import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
  fontSize: size.height * 0.060,
  fontWeight: FontWeight.bold,
);

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
  fontSize: size.height * 0.030,
);

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
    Size size,
    ) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Colors.deepPurpleAccent,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.white);
