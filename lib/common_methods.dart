import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bookmyevent/bloc/navbar_cubit.dart';
import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/app_images.dart';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/custom/components.dart';
import 'package:bookmyevent/dialog/dialog_utils.dart';
import 'package:bookmyevent/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math' as Math;

import 'package:url_launcher/url_launcher.dart';

import 'bloc/authCubit/auth_cubit.dart';

class CommonMethods {
  /// Space between two widget
  static Widget spacer({required double widgetHeight}) {
    return SizedBox(
      height: widgetHeight,
    );
  }

  static Future<String> getCountryPhoneCode(BuildContext context) async {
    var response = await get(Uri.parse('http://ip-api.com/json'));
    String? isoCode = "US";
    try {
      var jsonResponse = json.decode(response.body);
      isoCode = jsonResponse['countryCode'];
    } catch (e) {
      debugPrint("country exception------------${e.toString()}");
    }
    debugPrint("country code -------------api------- $isoCode");
    /* await MySharedPreferences.saveString(
        MySharedPreferences.isoCode, isoCode ?? "US");*/
    if (isoCode != null) {
      return isoCode;
    }
    isoCode = WidgetsBinding.instance.platformDispatcher.locale.countryCode ?? "US";
    debugPrint("country code ------------local-------- $isoCode");
    /*  await MySharedPreferences.saveString(
        MySharedPreferences.isoCode, isoCode ?? "US");*/
    return isoCode;
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 10) {
      return phoneNumber; // Return as is if the number is too short
    }

    // Keep the first 3 characters and the last 2 characters visible
    String visibleStart = phoneNumber.substring(0, 3);
    String visibleEnd = phoneNumber.substring(phoneNumber.length - 2);

    // Replace the middle part with asterisks
    String maskedPart = '*' * (phoneNumber.length - 5);

    return visibleStart + maskedPart + visibleEnd;
  }

  /* void main() {
    String phoneNumber = '+919876543210';
    String maskedPhoneNumber = maskPhoneNumber(phoneNumber);
    print(maskedPhoneNumber);  // Output: +91*******10
  }*/

  static Future<void> openScreens(BuildContext context) async {
    final isLongedIn = await MySharedPreferences.getBoolData(MySharedPreferences.isLongedIn);
    if (context.mounted) {
      if (isLongedIn) {
        context.go(Routes.homeScreenPath);
      } else {
        context.go(Routes.mobileVerificationScreenPath);
      }
    }
  }

  static String removeLeftString(String originalString, String specificText) {
    // Find the index of the specific text
    //int index = originalString.indexOf(specificText);

    /// if u also remove specific text
    int index = originalString.indexOf(specificText) + specificText.length;

    // If the specific text is found, extract the substring starting from that index
    if (index != -1) {
      return originalString.substring(index);
    } else {
      // If the specific text is not found, return the original string
      return originalString;
    }
  }

  static bool isNullEmptyOrFalse(dynamic o) {
    if (o is Map<String, dynamic> || o is List<dynamic>) {
      return o == null || o.length == 0;
    }
    return o == "" || o == "0.0" || o == "0" || o == null || o == false || o == "" || o == "guest" || o == "null";
  }

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static String apiErrorMessage({required String apiErrorMessage}) {
    /* InternalServerError = 1001,
    Unauthorized = 1002,
    AccountBan = 1003,
    ValidationFailed = 1004,
    BadRequest = 1005,
    EmailTaken = 1006,
    TokenExpire = 1007,
    NotFound = 1009,
    LoginRequired = 1010,
    NumberTaken = 1011,

    // Booking
    GroundNotAvailable = 2000,
    WalletBalanceInsufficient = 2001,
    AlreadyInGame = 2002,
    InvalidTimeSlot = 2003,*/

    String errorMessage = apiErrorMessage;
    debugPrint("apiErrorMessage----------$errorMessage");
    switch (apiErrorMessage) {
      case "errors.unauthorized":
        errorMessage = AppStrings.checkEmailAddressOrPassword;
        break;
      case "errors.token_expire":
        errorMessage = AppStrings.sessionExpired;
        break;
      case "errors.validation_failed":
        errorMessage = AppStrings.checkValidationFailed;
        break;
      case "Api Exception":
      case "errors.account_ban":
        errorMessage = AppStrings.checkYourAccountBan;
        break;
      case "errors.bad_request":
        errorMessage = AppStrings.badRequest;
        break;

      case "errors.user_has_already_parent":
        errorMessage = "User has already parent";
        break;

      case "errors.not_enough_boost":
        errorMessage = "Not enough boost";
        break;

      case "errors.email_taken":
        errorMessage = AppStrings.emailAlreadyTaken;
        break;
      case "errors.already_report_this_profile":
        errorMessage = AppStrings.toastAlreadyReported;
        break;
      case "errors.invalid_verification_code":
      case "errors.invalid_otp":
        errorMessage = AppStrings.invalidVerificationCode;
        break;
      case "errors.login_required":
        errorMessage = AppStrings.sessionExpired;
        break;
      case "errors.not_found":
        errorMessage = AppStrings.notFound;
        break;
      case "errors.internalServer":
        errorMessage = AppStrings.internalServerError;
        break;

      case "server Failure":
        errorMessage = AppStrings.internalServerError;
        break;
      case "connection Failure":
        errorMessage = AppStrings.internetConnectionError;
        break;
      default:
        errorMessage = errorMessage;
    }
    if (apiErrorMessage.contains("The connection errored")) {
      errorMessage = "Internet Connection Error";
    }
    debugPrint("apiErrorMessage----------$errorMessage");
    return errorMessage;
  }

  static getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static void showSnackBar(BuildContext context, String message, {color = AppColors.textColor, durationInSecond = 3}) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Align(
        alignment: Alignment.topCenter,
        child: Text(
          message, //'Copied to Clipboard',
          /*style: Constants.textStyle(
            size: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),*/
        ),
      ),
      duration: Duration(seconds: durationInSecond),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  //EpochTime
  static timeStamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static Widget loadImage({
    required String image,
    height = 0.0,
    width = 0.0,
    String placeholder = AppImages.appLogo,
    String errorPlaceholder = AppImages.appLogo,
    BoxFit boxFit = BoxFit.cover,
  }) {
    // debugPrint("Common---------loadImage-------$image");
    return !isNullEmptyOrFalse(image)
        ? height != 0 && width != 0
            ? CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => Container(
                  transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.77,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage(
                    errorPlaceholder,
                  ),
                  fit: BoxFit.fill,
                ),
                height: height,
                width: width,
                fit: boxFit,
              )
            : CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => Container(
                  transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.77,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage(
                    errorPlaceholder,
                  ),
                  fit: boxFit,
                ),
                fit: boxFit,
              )
        : height != 0 && width != 0
            ? Image(
                image: AssetImage(placeholder),
                height: height,
                width: width,
                fit: boxFit,
              )
            : Image(
                image: AssetImage(placeholder),
                fit: boxFit,
              );
  }

  static ImageProvider loadImageProvider({
    required String image,
    height = 0.0,
    width = 0.0,
    String placeholder = AppImages.appLogo,
    String errorPlaceholder = AppImages.appLogo,
  }) {
    // debugPrint("Common  loadImageProvider----------------$image");
    return !isNullEmptyOrFalse(image)
        ? height != 0.0 && width != 0.0
            ? FadeInImage(
                image: Image.network(
                  image,
                  fit: BoxFit.cover,
                  frameBuilder: (_, image, loadingBuilder, __) {
                    if (loadingBuilder == null) {
                      return SizedBox(
                        height: height,
                        width: width,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return image;
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      errorPlaceholder,
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (ctx, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      );
                    }
                  },
                ).image,
                placeholder: AssetImage(placeholder),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    errorPlaceholder,
                    fit: BoxFit.cover,
                  );
                },
                height: height,
                width: width,
                fit: BoxFit.cover,
              ).image
            : FadeInImage(
                image: Image.network(
                  image,
                  fit: BoxFit.cover,
                  frameBuilder: (_, image, loadingBuilder, __) {
                    if (loadingBuilder == null) {
                      return const SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return image;
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      errorPlaceholder,
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (ctx, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      );
                    }
                  },
                ).image,
                placeholder: AssetImage(placeholder),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    errorPlaceholder,
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
              ).image
        : Image(
            image: AssetImage(placeholder),
          ).image;
  }

  static void logoutAndClearSession(BuildContext context) async {
    await context.read<AuthCubit>().clearGoogleSignIn();
    context.read<NavbarCubit>().setHomeTab();
    await deleteLocalData();
    if (context.mounted) {
      context.go(Routes.mobileVerificationScreenPath);
    }
  }

  static void skipLogin(BuildContext context) async {
    /* final AuthRepository repository = AuthRepository(DioHelper());
    final result = await repository.guestLogin(context);

    if (result.isError == false) {
      debugPrint("loginApi--skipLogin---data---${result.data ?? ""}");
      final UserResponseModel responseBody =
          UserResponseModel.fromJson(result.data);
      String user = jsonEncode(responseBody);
      MySharedPreferences.saveString(MySharedPreferences.userData, user);
    }*/

    MySharedPreferences.saveBoolData(MySharedPreferences.isSkipLongedIn, true);
    context.go(Routes.homeScreenPath);
  }

  static deleteLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static String capitalizedString(String myString) {
    String capitalizedString = myString.split(' ').take(2).map((word) => word[0].toUpperCase()).join('');
    return capitalizedString;
  }

  static String displayKm(dynamic distance) {
    double distanceDouble = 0.0;
    if (distance != null) {
      distanceDouble = double.parse(distance.toString()) / 1000;
    }
    return "${distanceDouble.toStringAsFixed(2)} KM";
  }

  static String removeUnderScore(String myString) {
    return myString.replaceAll('_', ' ').toUpperCase();
  }

  static bool isValidEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isValidPassword(String password) {
    String p = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(password);
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static String feetToCm(double feet) {
    return (feet * 30.48).toStringAsFixed(0);
  }

  static String cmToFeet(double cm) {
    return (cm / 30.48).toStringAsFixed(1);
  }

  static int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  static String readTimestamp(int timestamp, {String newFormat = "d MMMM HH:mm a"}) {
    if (timestamp == 0) {
      return "No Any Message";
    }
    var format = DateFormat(newFormat);
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    var time = format.format(date); // Doesn't get called when it should be
    return time;
  }

  static String displayMiles(int distance) {
    // ${item.distance} Miles
    ///    convert meter to mile (distance is meter)
    var mileFromMeter = distance / 1609.344;
    if (mileFromMeter < 1) {
      return "< 1 Mile";
    } else if (mileFromMeter == 1) {
      return "1 Mile";
    }
    return "${mileFromMeter.toStringAsFixed(2)} Miles";
  }

  static double convertMeterToMiles(int distance) {
    // ${item.distance} Miles
    ///    convert meter to mile (distance is meter)

    var mileFromMeter = distance / 1609.344;
    if (mileFromMeter <= 1) {
      return 0.0;
    }
    return mileFromMeter;
  }

  static double convertMilesToMeter(int distance) {
    ///  convert mile to meter   (distance is mile)
    var mileFromMeter = distance * 1609.344;
    if (mileFromMeter < 1) {
      return 0.0;
    }
    return mileFromMeter;
  }

  static String convertDateFormat(String dateTimeString, String oldFormat, String newFormat) {
    DateFormat newDateFormat = DateFormat(newFormat);
    DateTime dateTime = DateFormat(oldFormat).parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }

  static String getCurrentDate({String newFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"}) {
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
    /// yyyy-MM-ddTHH:mm:ssZ
    /// yyyy-MM-ddTHH:mm:ss
    return DateFormat(newFormat).format(DateTime.now());
  }

  static String getAge(String birthDateString) {
    // Parse the date string
    DateTime birthDate = DateTime.parse(birthDateString);
    // Get the current date
    DateTime currentDate = DateTime.now();
    // Calculate the age
    int age = currentDate.year - birthDate.year;
    // Adjust age if the birth date has not occurred yet this year
    if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  static String convertAgeToDateOfBirth(int age) {
    //yyyy-MM-dd
    final DateTime now = DateTime.now();
    final DateTime dateOfBirth = DateTime(now.year - age, now.month, now.day);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateOfBirth);
  }

  static String camelCaseString(String text) {
    if (text.isEmpty) {
      return "";
    }
    String replaceStr = text.replaceAll('_', ' ');
    final exp = RegExp('(?<=[a-z])[A-Z]');
    String result = replaceStr.replaceAllMapped(exp, (m) => '_${m.group(0)}');
    // return result.capitalizeFirst ?? "";
    return result;
  }

  /* static TextStyle getHintTextStyle(context, hint, {color = Colors.black}) {
    return Constants.textStyle(
        size: 16,
        color: hint ? Colors.grey.shade400 : color,
        fontWeight: FontWeight.w400);
  }*/

  static Future<String> getAppVersion() async {
    String appVersion = "0.0.1";
    /* PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try {
      appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
      debugPrint("packageInfo $appVersion");
    } catch (e) {
      debugPrint("packageInfo Exc----------${e.toString()}");
    }*/
    return appVersion;
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  static void openRequireLoginDialog(BuildContext context) {
    DialogUtils.showCustomUiDialog(
      context,
      title: AppStrings.requiredLogin,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              AppStrings.loginRequiredMessage,
              textAlign: TextAlign.center,
              style: Constants.textStyle(
                size: 15,
                color: AppColors.textColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                width: 80,
                height: 40,
                buttonText: AppStrings.cancel,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 10,
              ),
             /* CustomButton(
                width: 80,
                height: 40,
                buttonText: AppStrings.yes,
                onPressed: () async {
                  context.pop();
                  context.pushNamed(
                    Routes.mobileVerificationScreenName,
                    extra: {
                      Constants.passIsSkip: false,
                    },
                  );
                },
              ),*/
            ],
          )
        ],
      ),
    );
  }

  static Future<void> openLaunchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

/* static Future<int> requestPermission() async {
    Location location = Location();

    /// after enable location service get service enable status
    var serviceEnabled = await location.serviceEnabled();
    bool serviceRequest = false;
    bool hasPermission = false;
    if (!serviceEnabled) {
      hasPermission = false;
      serviceRequest = await location.requestService();
    } else {
      hasPermission = true;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint("handleLocationPermission-checkPermission:  $permission");
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ///Location permissions are denied
      debugPrint("handleLocationPermission-denied=============:  $permission");
      */ /* if (context.mounted) {
        await Geolocator.openAppSettings();
      }*/ /*
      hasPermission = false;
      return 0;
    }

    debugPrint(
        "requestPermissionForAndroid---------serviceRequest: $serviceRequest");
    debugPrint(
        "requestPermissionForAndroid---------serviceEnabled: $serviceEnabled");
    debugPrint(
        "requestPermissionForAndroid---------hasPermission: $hasPermission");
    bool accessLocation = serviceEnabled && hasPermission;
    if (accessLocation) {
      return 1;
    }
    return -1;
  }*/
}
