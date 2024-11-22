import 'dart:convert';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:bookmyevent/common_methods.dart';
import 'package:bookmyevent/core/app_config.dart';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/data/common_response_model.dart';
import 'package:bookmyevent/provider/internet_provider.dart';
import 'package:bookmyevent/services/network_method_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DioHelper {
  /// apis end points
  String firebaseAuth = "/v1/auth/firebase";
  String guestLogin = "/v1/auth/guest-login";
  String userNameLogin = "/v1/auth/username-login";
  String userLogout = "/v1/auth/logout";
  String userPhoneNumberExits = "/v1/auth/phoneNumber-verify";
  String verifyEmailSend = "/v1/auth/verify-email-send";
  String forgotEmailSend = "/v1/auth/forgot-email-send";
  String verifyEmail = "/v1/auth/verify-email";
  String updateProfile = "/v1/user/info";
  String deleteAccount = "/v1/user/delete-account";
  String me = "/v1/user/me";
  String userNameCheck = "/v1/auth/username-verify";
  String uploadPhoto = "/v1/user/profile-sign-url";

  String contactUs = "/v1/general/contact-us";
  String churchList = "/v1/church/listing";
  String churchNearByList = "/v1/church/nearby";
  String churchJoinedList = "/v1/church/join-church-listing";
  String churchDetails = "/v1/church/details/";
  String joinChurch = "/v1/church/joinOrLeave/";
  String joinVolunteer = "/v1/church/joinOrLeave/volunteer/";
  String eventList = "/v1/event/listing";
  String notesList = "/v1/notes/listing";
  String volunteerList = "/v1/church/volunteer/listing";
  String addNotes = "/v1/notes";
  String updateNotes = "/v1/notes/";
  String updateNotesEndPoint = "/update";
  String deleteNotes = "/v1/notes";
  String eventsDetails = "/v1/event/";
  String detail = "/detail";
  String joinEvent = "/v1/event/";
  String joinEventEndPoint = "/join-or-leave";
  String musicListing = "/v1/music-audio/listing";
  String dailyScriptureList = "/v1/general/daily-scripture";

  String homeBannerList = "/v1/general/banners";
  String notificationList = "/v1/general/Notification";

  /// prayer apis
  String prayerRequest = "/v1/prayer-request";
  String prayerRequestList = "/v1/prayer-request/listing";
  String prayerCancelRequestEndPoint = "/cancel-request";

  /// donation apis
  String donation = "/v1/donation";
  String donationCategory = "/v1/donation/category";
  String donationHistory = "/v1/donation/user-history";


  String favouriteList = "/v1/user/favourite";
  String favouriteLikeDislike = "/v1/general/";
  String favouriteLikeDislikeEndPoint = "/like-dislike";

  String quizList = "/v1/quiz/listing";
  String quizDetail = "/v1/quiz/";
  String success = "/success";


  String chat = "/v1/chat";
  String uploadChatPhotoS3 = "/v1/chat/s3-sign-urls";
  String storeMessage = "/v1/chat/store-message";
 // String addQuizScore = "/v1/quiz/";

  late Dio _dio;

  DioHelper() {
    _dio = Dio(
      BaseOptions(
        // baseUrl: 'http://api.bengkelrobot.net:8001/api',
        baseUrl: AppConfig.shared.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        // 60 seconds
        receiveTimeout: const Duration(seconds: 60),
        // 60
        sendTimeout: const Duration(seconds: 60), // 60
      ),
    );
    //_dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(
      AwesomeDioInterceptor(
        // Disabling headers and timeout would minimize the logging output.
        // Optional, defaults to true
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,

        // Optional, defaults to the 'log' function in the 'dart:developer' package
        logger: debugPrint,
      ),
    );
  }

  Future<CommonResponseModel> commonApiCall(
    String endPoint, {
    required BuildContext context,
    NetworkMethodType methodType = NetworkMethodType.GET,
    bool isHeader = false,
    bool isHeaderVersion = false,
    Object postObj = const {},
  }) async {
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      return CommonResponseModel(
          message: AppStrings.internetConnectionError,
          code: 503,
          isError: true);
    }
    try {
      if (isHeader) {
       /* UserResponseModel? userData =
            await MySharedPreferences.userResponseData();
        if (userData != null) {
          _dio.options.headers['authorization'] = 'Bearer ${userData.token}';
          _dio.options.headers['Content-Type'] = 'application/json';
          debugPrint(
              "DioHelper commonApiCall-----headers authorization----------token: ${userData.token}");
        }*/
      } else {
        _dio.options.headers['authorization'] = '';
      }
      if (isHeaderVersion) {
        final version =
            await MySharedPreferences.getIntData(MySharedPreferences.version);
        _dio.options.headers['version'] = version;
      }

      // Use switch-case to assign the response based on the method type
      var response = await (switch (methodType) {
        NetworkMethodType.GET => _dio.get(endPoint),
        NetworkMethodType.POST => !CommonMethods.isNullEmptyOrFalse(postObj)
            ? _dio.post(endPoint, data: postObj)
            : _dio.post(endPoint),
        NetworkMethodType.PATCH => _dio.patch(endPoint, data: postObj),
        NetworkMethodType.DELETE => _dio.delete(endPoint, data: postObj),
      });
      debugPrint(
          "DioHelper commonApiCall----------------statusCode: ${response.statusCode} ");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final CommonResponseModel responseBody =
            CommonResponseModel.fromJson(json.decode(response.toString()));
        return responseBody;
      } else if (response.statusCode == 204) {
        return CommonResponseModel(message: "", code: 204, isError: false);
      } else if (response.statusCode == 1007 ||
          response.statusCode == 1010 ||
          response.statusCode == 1003 ||
          response.statusCode == 1002 ||
          response.statusCode == 401) {
        if (context.mounted) {
          CommonMethods.logoutAndClearSession(context);
        }
      }
      return CommonResponseModel(
          message: CommonMethods.apiErrorMessage(
              apiErrorMessage: response.statusMessage ?? ""),
          code: response.statusCode,
          isError: true);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      final response = e.response;
      if (response != null) {
        debugPrint(
            "DioHelper DioException data----------------- ${response.data}");
        int statusCode = 500;
        String message = response.statusMessage ?? "";
        try {
          statusCode = response.data["code"];
          message = response.data["message"];
        } catch (e) {
          debugPrint("commonApiCall $e");
        }
        debugPrint(
            "DioHelper commonApiCall DioException code----------------- $statusCode");
        debugPrint(
            "DioHelper commonApiCall DioException headers ----------------${response.headers}");
        debugPrint(
            "DioHelper commonApiCall DioException statusCode----------------- ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          final CommonResponseModel responseBody =
              CommonResponseModel.fromJson(json.decode(response.toString()));
          return responseBody;
        } else if (response.statusCode == 204) {
          return CommonResponseModel(message: "", code: 204, isError: false);
        } else if (response.statusCode == 1007 ||
            response.statusCode == 1010 ||
            response.statusCode == 1003 ||
            response.statusCode == 1002 ||
            response.statusCode == 401) {
          if (context.mounted) {
            CommonMethods.logoutAndClearSession(context);
          }
        }

        return CommonResponseModel(
            message: CommonMethods.apiErrorMessage(apiErrorMessage: message),
            code: response.statusCode,
            isError: true);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(
            "DioHelper commonApiCall DioException requestOptions ${e.requestOptions}");
        debugPrint("DioHelper commonApiCall DioException message ${e.message}");
        var message = e.message ?? AppStrings.errorMessage;
        return CommonResponseModel(
            message: CommonMethods.apiErrorMessage(apiErrorMessage: message),
            code: e.hashCode,
            isError: true);
      }
    }
  }

  Future<CommonResponseModel> commonImageUploadApiCall(String endPoint,
      {required BuildContext context,
      NetworkMethodType methodType = NetworkMethodType.GET,
      bool isHeader = false,
      bool isHeaderVersion = false,
      Object postObj = const {}}) async {
    try {
      if (isHeader) {
      /*  UserResponseModel? userData =
            await MySharedPreferences.userResponseData();
        if (userData != null) {
          _dio.options.headers['authorization'] = 'Bearer ${userData.token}';
          debugPrint(
              "DioHelper commonApiCall-----headers authorization----------token: ${userData.token}");
        }*/
      } else {
        _dio.options.headers['authorization'] = '';
      }


      var response = await (switch (methodType) {
        NetworkMethodType.GET => _dio.get(endPoint),
        NetworkMethodType.POST => !CommonMethods.isNullEmptyOrFalse(postObj)
            ? _dio.post(endPoint, data: postObj)
            : _dio.post(endPoint),
        NetworkMethodType.PATCH => _dio.patch(endPoint, data: postObj),
        NetworkMethodType.DELETE => _dio.delete(endPoint, data: postObj),
      });

      /*var response;
      if (methodType == NetworkMethodType.GET) {
        response = await _dio.get(endPoint);
      } else if (methodType == NetworkMethodType.POST) {
        if (!CommonMethods.isNullEmptyOrFalse(postObj)) {
          response = await _dio.post(endPoint, data: postObj,
              onSendProgress: (int sent, int total) {
            debugPrint(
                "DioHelper commonApiCall-----sent $sent----------total: $total");
            *//* setState(() {
                  pm.progress = (sent / total) * 100;
                });*//*
          });
        } else {
          response = await _dio.post(
            endPoint,
          );
        }
      } else if (methodTye == NetworkMethodType.PATCH) {
        response = await _dio.patch(
          endPoint,
          data: postObj,
        );
      } else if (methodTye == NetworkMethodType.DELETE) {
        response = await _dio.delete(endPoint);
      }*/

      debugPrint(
          "DioHelper commonApiCall----------------statusCode: ${response.statusCode} ");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final CommonResponseModel responseBody =
            CommonResponseModel.fromJson(json.decode(response.toString()));
        return responseBody;
      } else if (response.statusCode == 204) {
        return CommonResponseModel(message: "", code: 204, isError: false);
      } else if (response.statusCode == 1007 ||
          response.statusCode == 1010 ||
          response.statusCode == 1003 ||
          response.statusCode == 1009 ||
          response.statusCode == 1002 ||
          response.statusCode == 401) {
        if (context.mounted) {
          CommonMethods.logoutAndClearSession(context);
        }
      }
      return CommonResponseModel(
          message: CommonMethods.apiErrorMessage(
              apiErrorMessage: response.statusMessage ?? ""),
          code: response.statusCode,
          isError: true);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      final response = e.response;
      if (response != null) {
        debugPrint(
            "DioHelper DioException data----------------- ${response.data}");
        int statusCode = 500;
        String message = response.statusMessage ?? "";
        try {
          statusCode = response.data["code"];
          message = response.data["message"];
        } catch (e) {
          debugPrint("commonApiCall $e");
        }
        debugPrint(
            "DioHelper commonApiCall DioException code----------------- $statusCode");
        debugPrint(
            "DioHelper commonApiCall DioException headers ----------------${response.headers}");
        debugPrint(
            "DioHelper commonApiCall DioException requestOptions------------ ${response.requestOptions}");
        debugPrint(
            "DioHelper commonApiCall DioException statusCode----------------- ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          final CommonResponseModel responseBody =
              CommonResponseModel.fromJson(json.decode(response.toString()));
          return responseBody;
        } else if (response.statusCode == 204) {
          return CommonResponseModel(message: "", code: 204, isError: false);
        } else if (response.statusCode == 1007 ||
            response.statusCode == 1010 ||
            response.statusCode == 1003 ||
            response.statusCode == 1009 ||
            response.statusCode == 1002 ||
            response.statusCode == 401) {
          if (context.mounted) {
            CommonMethods.logoutAndClearSession(context);
          }
        }

        return CommonResponseModel(
            message: CommonMethods.apiErrorMessage(apiErrorMessage: message),
            code: response.statusCode,
            isError: true);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(
            "DioHelper commonApiCall DioException requestOptions ${e.requestOptions}");
        debugPrint("DioHelper commonApiCall DioException message ${e.message}");
        var message = e.message ?? AppStrings.errorMessage;
        return CommonResponseModel(
            message: CommonMethods.apiErrorMessage(apiErrorMessage: message),
            code: e.hashCode,
            isError: true);
      }
    }
  }

  Future<CommonResponseModel> commonQueryApiCall(
    String endPoint,
    Map<String, dynamic> queryParameters, {
    required BuildContext context,
    NetworkMethodType methodType = NetworkMethodType.GET,
    bool isHeader = false,
    Object postObj = Object,
  }) async {
    if (context.mounted) {
      final ip = context.read<InternetProvider>();
      await ip.checkInternetConnection();
      if (ip.hasInternet == false) {
        return CommonResponseModel(
            message: AppStrings.internetConnectionError,
            code: 503,
            isError: true);
      }
    }

    try {
      if (isHeader) {
        /*UserResponseModel? userData =
            await MySharedPreferences.userResponseData();
        if (userData != null) {
          _dio.options.headers['authorization'] = 'Bearer ${userData.token}';
          _dio.options.headers['Content-Type'] = 'application/json';

          debugPrint(
              "DioHelper commonQueryApiCall-----headers authorization----------token: ${userData.token}");
        }*/
      }

      // Use switch-case to assign the response based on the method type
      var response = await (switch (methodType) {
        NetworkMethodType.GET => queryParameters.isNotEmpty
            ? _dio.get(endPoint, queryParameters: queryParameters)
            : _dio.get(endPoint),
        NetworkMethodType.POST => _dio.post(endPoint, data: postObj),
        NetworkMethodType.PATCH => _dio.patch(endPoint, data: postObj),
        NetworkMethodType.DELETE => _dio.delete(endPoint),
      });

      debugPrint(
          "DioHelper commonQueryApiCall----------------statusCode: ${response.statusCode} ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final CommonResponseModel responseBody =
            CommonResponseModel.fromJson(json.decode(response.toString()));
        return responseBody;
      } else if (response.statusCode == 204) {
        return CommonResponseModel(message: "", code: 204, isError: false);
      } else if (response.statusCode == 1007 ||
          response.statusCode == 1010 ||
          response.statusCode == 1003 ||
          response.statusCode == 1002 ||
          response.statusCode == 1009) {
        if (context.mounted) {
          CommonMethods.logoutAndClearSession(context);
        }
      }
      return CommonResponseModel(
          message: CommonMethods.apiErrorMessage(
              apiErrorMessage: response.statusMessage ?? ""),
          code: response.statusCode,
          isError: true);
    } on DioException catch (e) {
      debugPrint("DioHelper commonQueryApiCall DioException  ${e.toString()}");
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      final response = e.response;
      if (response != null) {
        debugPrint("DioHelper commonQueryApiCall ${response.data}");
        debugPrint("DioHelper commonQueryApiCall ${response.headers}");
        debugPrint("DioHelper commonQueryApiCall ${response.requestOptions}");
        int statusCode = 500;
        String message = response.statusMessage ?? "";

        try {
          statusCode = response.data["code"];
          debugPrint("DioHelper statusCode  code $e");
          message = response.data["message"];
        } catch (e) {
          debugPrint("DioHelper commonApiCall $e");
        }
        if (statusCode == 1007 ||
            statusCode == 1010 ||
            statusCode == 1003 ||
            statusCode == 1002 ||
            statusCode == 1009) {
          if (context.mounted) {
            CommonMethods.logoutAndClearSession(context);
          }
        }
        return CommonResponseModel(
            message: CommonMethods.apiErrorMessage(apiErrorMessage: message),
            code: response.statusCode,
            isError: true);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(
            "DioHelper commonQueryApiCall requestOptions data: ${e.response?.data}");
        debugPrint("DioHelper commonQueryApiCall ${e.message}");
        return CommonResponseModel(
            message:
                CommonMethods.apiErrorMessage(apiErrorMessage: e.message ?? ""),
            code: e.hashCode,
            isError: true);
      }
    }
  }
}
