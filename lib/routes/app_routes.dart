import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/routes/routes.dart';
import 'package:bookmyevent/ui/main_screen.dart';
import 'package:bookmyevent/ui/mobile_verification_screen.dart';
import 'package:bookmyevent/ui/otp_verification_screen.dart';
import 'package:bookmyevent/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.rootPath,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: Routes.rootPath,
        name: Routes.rootName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.homeScreenPath,
        name: Routes.homeNameScreen,
        builder: (context, state) => const MainScreen(),
      ),

      GoRoute(
        path: Routes.mobileVerificationScreenPath,
        name: Routes.mobileVerificationScreenName,
        builder: (context, state) => const MobileVerificationScreen(),
      ),
      GoRoute(
        path: Routes.otpVerificationScreenPath,
        name: Routes.otpVerificationScreenName,
        builder: (context, state) =>
            OtpVerificationScreen(arguments: state.extra),
      ),

    ],
    errorBuilder: (context, state) => const Center(
      child: Text(
        "No Page",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textColor,
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
