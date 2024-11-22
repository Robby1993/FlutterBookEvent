import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkSession(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _checkSession(BuildContext context) async {
    final isLongedIn = await MySharedPreferences.getBoolData(MySharedPreferences.isLongedIn);
    if (!context.mounted) return;
    if (isLongedIn) {
      context.go(Routes.homeScreenPath);
    } else if (!isLongedIn) {
      context.go(Routes.mobileVerificationScreenPath);
    }
  }
}
