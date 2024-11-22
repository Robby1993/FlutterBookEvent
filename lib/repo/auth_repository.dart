import 'dart:convert';
import 'dart:io';

import 'package:bookmyevent/core/constants.dart';
import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/data/common_response_model.dart';
import 'package:bookmyevent/services/dio_helper.dart';
import 'package:bookmyevent/services/network_method_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final DioHelper service;

  AuthRepository(this.service);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> getUser() async {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  Future<CommonResponseModel> login(
    BuildContext context,
    String token,
    String onesignalId, {
    String username = "",
    String phoneNumber = "",
  }) async {
    Map<String, dynamic> provider;



    String platform = "";
    String appVersion = "";
    String manufacturer = "";
    String deviceOSVersion = "";
    String deviceModel = "";


    Object postObj = jsonEncode({
      'onesignalId': onesignalId,
      if (username.isNotEmpty) 'userName': username,
      if (phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
      'token': token,

      "appVersion": appVersion,
      "platform": platform,
      "deviceManufacturer": manufacturer,
      "deviceOSVersion": deviceOSVersion,
      "deviceModel": deviceModel,
    });
    return await service.commonApiCall(
        context: context,
        service.firebaseAuth,
        methodType: NetworkMethodType.POST,
        postObj: postObj);
  }

  Future<CommonResponseModel> updateProfile(
    BuildContext context,
    Object postObj,
  ) async {
    return await service.commonApiCall(
      context: context,
      service.updateProfile,
      postObj: postObj,
      isHeader: true,
      methodType: NetworkMethodType.PATCH,
    );
  }

  Future<CommonResponseModel> logOut(
    BuildContext context,
  ) async {
    return await service.commonApiCall(
      context: context,
      service.userLogout,
      isHeader: true,
    );
  }

  Future<CommonResponseModel> guestLogin(
    BuildContext context,
  ) async {
    return await service.commonApiCall(
      context: context,
      service.guestLogin,
    );
  }

  Future<CommonResponseModel> userNameLogin(
      BuildContext context, String username) async {
    Object postObj = jsonEncode({
      'userName': username,
    });
    return await service.commonApiCall(
        context: context,
        service.userNameLogin,
        methodType: NetworkMethodType.POST,
        postObj: postObj);
  }

  Future<CommonResponseModel> checkEmailExits(
      BuildContext context, String email) async {
    Object postObj = jsonEncode({
      'email': email,
    });
    return await service.commonApiCall(
      context: context,
      service.forgotEmailSend,
      methodType: NetworkMethodType.POST,
      postObj: postObj,
    );
  }

  Future<CommonResponseModel> checkPhoneNumber(
      BuildContext context, String phoneNumber) async {
    Object postObj = jsonEncode({
      'phoneNumber': phoneNumber,
    });
    return await service.commonApiCall(
        context: context,
        service.userPhoneNumberExits,
        methodType: NetworkMethodType.POST,
        postObj: postObj);
  }

  Future<CommonResponseModel> emailSendCode(
      BuildContext context, String email, String username) async {
    Object postObj = jsonEncode({
      'email': email,
      'userName': username,
    });
    return await service.commonApiCall(
      context: context,
      service.verifyEmailSend,
      methodType: NetworkMethodType.POST,
      postObj: postObj,
    );
  }

  Future<CommonResponseModel> verifyEmail(
      BuildContext context, Map<String, dynamic> queryParams) async {
    return await service.commonApiCall(
      context: context,
      service.verifyEmail,
      methodType: NetworkMethodType.POST,
      isHeader: false,
      postObj: queryParams,
    );
  }

  Future<CommonResponseModel> contactUs(
      BuildContext context, Object obj) async {
    return await service.commonApiCall(
      context: context,
      service.contactUs,
      isHeader: true,
      postObj: obj,
      methodType: NetworkMethodType.POST,
    );
  }
}
