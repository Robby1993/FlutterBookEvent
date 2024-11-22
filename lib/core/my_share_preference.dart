import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static String isLongedIn = "isLongedIn";
  static String isSkipLongedIn = "isSkipLongedIn";


  static String balance = "BALANCE";
  static String isOnBoarding = "isOnBoarding";
  static String interest = "interest";
  static String sparkStarter = "sparkStarter";
  static String language = "language";
  static String traits = "traits";
  static String version = "version";
 // static String profileMode = "mode";
  static String isBiometrics = "isBiometrics";
  static String isoCode = "isoCode";
  static String homeTown = "homeTown";

  /// filter
  static String distance = "distance";
  static String gender = "gender";
  static String onlyVerified = "onlyVerified";
  static String minHeight = "minHeight";
  static String maxHeight = "maxHeight";
  static String drink = "drink";
  static String smock = "smock";
  static String exercise = "exercise";
  static String lookingFor = "lookingFor";
  static String children = "children";
  static String starSing = "starSing";
  static String religion = "religion";
  static String isLiked = "isLiked";
  static String todayQuote = "todayQuote";

  /* read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }*/

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  getString(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString(key);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<SharedPreferences> getSharedPref() {
    return SharedPreferences.getInstance();
  }

  /// saving data

  // Saving String to Shared Preferences
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // Saving Bool to Shared Preferences
  static void saveBoolData(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<void> saveBoolWaitData(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Saving String to Shared Preferences
  static void saveStringData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

// Saving Int to Shared Preferences
  static void saveIntData(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

// Saving Double to Shared Preferences
  static void saveDoubleData(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  /// reading data

  // Reading String to Shared Preferences
  static Future<String> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  // Reading String to Shared Preferences
  /*static Future<List<PreferenceOptionModel>> getStringList(String key) async {
    final getStartList = await getStringData(key);
    debugPrint("build getStartList-----------------------------$getStartList-");
    if (getStartList.isNotEmpty) {
      //  return json.decode(getStartList).cast<PreferenceOptionModel>().toList();
      //  final item = json.decode(json.encode(getStartList));
      List<dynamic> list = json.decode(getStartList);
      return List<PreferenceOptionModel>.from(
          list.map((x) => PreferenceOptionModel.fromJson(x)));
    }
    return [];
  }*/

// Reading Int to Shared Preferences
  static Future<int> getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

// Reading Double to Shared Preferences
  static Future<double> getDoubleData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

// Reading Bool to Shared Preferences
  static Future<bool> getBoolData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  // removing data from Shared Preferences
  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  // removing data from Shared Preferences
  static Future<bool> checkValueExistence(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

 /* static Future<UserResponseModel?> userResponseData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(MySharedPreferences.userData) ?? "";
    if (data.isEmpty) {
      return UserResponseModel();
    }
    Map<String, dynamic> json = jsonDecode(data);
    var profileData = UserResponseModel.fromJson(json);
    return profileData;
  }*/

  /* static Future<PreferenceResponseModel?> getPreferenceData(String key) async {
     final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key) ?? "";
    if (data.isEmpty) {
      return PreferenceResponseModel(name: "", title: "", options: []);
    }
    Map<String, dynamic> json = jsonDecode(data);
    var finalData = PreferenceResponseModel.fromJson(json);
    return finalData;
  }*/


  static void logoutAndClearSession(BuildContext context) async {
    // context.read<NavbarCubit>().reset();
    Navigator.pop(context);
    //BlocProvider.of<NavbarCubit>(context).changeBottomNavBar(0);
    //  BlocProvider.of<AuthCubit>(context).logOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      // Navigator.of(context).pushNamedAndRemoveUntil(PageName.firstPage, (Route route) => false);
    }
  }
}
