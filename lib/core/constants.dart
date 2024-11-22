import 'package:bookmyevent/core/app_color.dart';
import 'package:flutter/material.dart';

class Constants {
  ///font
  static String fontPrompt = "prompt";
  static String kGoogleApiKey = "AIzaSyDwFsMth1oxa6_eX4eptGvzwvZmtHVgl-w";
  static String linkPolicy = "https://www.africanluv.com/security-and-privacy.html";
  static String linkFaq = "https://www.africanluv.com/faq.html";
  static String linkTermsCondition = "https://www.africanluv.com/terms-and-condition.html";

  static String providerGoogle = "Google";
  static String providerApple = "Apple";
  static String providerEmail = "email";
  static String isGuestMode = "isGuestMode";

  static String passNumber = "passNumber";
  static String passEmail = "passEmail";
  static String passName = "passName";
  static String passAddress = "passAddress";
  static String passDOB = "passDOB";
  static String passPass = "passPass";
  static String passData = "passData";
  static String passUserName = "passUserName";
  static String passProvider = "passProvider";
  static String passIosCode = "passIosCode";
  static String passVerificationId = "passVerificationId";
  static String passTitle = "passTitle";
  static String passScore = "passScore";
  static String passIsSkip = "passIsSkip";
  static String passReason = "passReason";
  static String passMapData = "passMapData";
  static String passChatId = "passChatId";


  static String serverDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
  static String dateFormat = "MM-dd-yyyy";

  static const String url = "url";
  static const String urls = "urls";
  static const String imageIndex = "imageIndex";
  static const String isParentSetup = "isRegister";

  static TextStyle textStyle({
    Color color = AppColors.textColor,
    double size = 15,
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      decoration: decoration,
      decorationColor: color,
      decorationThickness: 1,
      color: color,
      fontSize: size,
      letterSpacing: -0.3,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
    );
  }

}
