import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:bookmyevent/routes/animated_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  const AppTheme();

  /// Theme.of(context).textTheme.bodySmall!.copyWith(fontSize:40),
  static ThemeData lightThem() {
    return ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomPageTransitionBuilder(),
          TargetPlatform.iOS: CustomPageTransitionBuilder(),
        },
      ),
      textTheme: const TextTheme(
        //display Small
        displaySmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),

        //Body Small
        bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),

        //Body Medium
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),

        //Body Large
        bodyLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.black),

        //Title Medium
        titleMedium: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),

        //Title Medium
        titleLarge: TextStyle(fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.screenBG,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      // fontFamily: Constants.fontPrompt,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        //  primary: const AppColors.primaryColor,
        surface: AppColors.screenBG,

        /// set app background color
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.screenBG,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.black,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      fontFamily: Constants.fontPrompt,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        //  primary: const AppColors.primaryColor,
        surface: AppColors.screenBG,

        /// set app background color
      ),
    );
  }
}
