import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  /// path
  static const rootPath = '/';
  static const homeScreenPath = '/homeScreenPath';
  static const noFoundScreenPath = '/noFoundScreenPath';
  static const mobileVerificationScreenPath = '/mobileVerificationScreenPath';
  static const otpVerificationScreenPath = '/otpVerificationScreenPath';

  /// name
  static const rootName = 'root';
  static const homeNameScreen = 'home';
  static const noFoundName = 'notFoundScreen';
  static const mobileVerificationScreenName = 'mobileVerificationScreenName';
  static const otpVerificationScreenName = 'otpVerificationScreenName';


  static Widget errorWidget(BuildContext context, GoRouterState state) => Container();
}
