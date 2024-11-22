import 'dart:convert';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/data/common_response_model.dart';
import 'package:bookmyevent/repo/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthLoggedInState(currentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }

  void sendOTP(
    BuildContext context,
    String phoneNumber, {
    bool resend = false,
  }) async {
    debugPrint("sendOTP phoneNumber $phoneNumber");
    if (resend) {
      emit(AuthOtpVerifyLoadingState());
    } else {
      emit(AuthLoadingState());

      final result = await checkPhoneNumber(context, phoneNumber);
      if (result.isError == true) {
        emit(AuthErrorState(AppStrings.toastPhoneNumberExits));
        return;
      }
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 20),
      codeSent: (verificationId, forceResendingToken) {
        // _verificationId = verificationId;
        if (resend) {
          emit(AuthCodeReSentState(verificationId));
        } else {
          emit(AuthCodeSentState(verificationId));
        }
      },
      verificationCompleted: (phoneAuthCredential) {
        emit(AuthVerifyCodeState(phoneAuthCredential.smsCode ?? ""));
      },
      verificationFailed: (error) {
        if (resend) {
          emit(AuthVerifyErrorState(error.message.toString()));
        } else {
          emit(AuthErrorState(error.message.toString()));
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        emit(AuthTimeOutErrorState("Time out"));
        //_verificationId = verificationId;
        // emit(AuthErrorTimeOutState("Time out"));
      },
    );
  }

  void verifyOTP(
    BuildContext context,
    String mobileNumber,
    String otp,
    String verificationId, {
    bool isOtpVerify = false,
  }) async {
    debugPrint("--------------------------------verifyOTP");
    emit(AuthOtpVerifyLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    signInWithPhone(
      context,
      credential,
      mobileNumber,
      isOtpVerify: isOtpVerify,
    );
  }

  void signInWithPhone(
    BuildContext context,
    PhoneAuthCredential credential,
    String mobileNumber, {
    bool isOtpVerify = false,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.currentUser!.linkWithCredential(credential);
      /*  if (AppConfig.shared.flavor == Flavor.dev) {
        _auth.setSettings(appVerificationDisabledForTesting: true);
      }*/
      final user = userCredential.user;
      if (user != null) {
        //  Phone number successfully linked to the Google account
        /// if otp match success state call
        // emit(AuthLoggedInState(user!));
        /// Server side manage:  if u want to call api and pass token so get token and call api

       /* var token = await user.getIdToken();
        final provider = await MySharedPreferences.getStringData(
            MySharedPreferences.providerData);*/

        if (context.mounted) {
          /// phone  verified


           Map<String, dynamic> map = {
            "phoneNumber": mobileNumber,
          };
          final result = await repository.updateProfile(
            context,
            map,
          );
          if (result.isError == false) {
          //  emit(AuthLoggedApiInState(UserResponseModel()));
          } else {
            if (isOtpVerify) {
              emit(AuthVerifyErrorState(
                  result.message ?? AppStrings.errorMessage));
            } else {
              emit(AuthErrorState(result.message ?? AppStrings.errorMessage));
            }
          }
          /* loginApiAndSaveDataToFireStore(context, token ?? "",
              isOtpVerify: isOtpVerify, phoneNumber: mobileNumber);*/
        }
      }
    } on FirebaseAuthException catch (ex) {
      debugPrint(
          "isLongedIn---------------- FirebaseAuthException-----------${ex.message.toString()}");
      debugPrint(
          "isLongedIn---------------- FirebaseAuthException- code----------${ex.code}");

      if (ex.code == 'credential-already-in-use') {
        //get the credentials of the new linking account
      }else if (ex.code == 'provider-already-linked') {
        //get the credentials of the new linking account
        if (context.mounted) {
          /// phone  verified

          Map<String, dynamic> map = {
            "phoneNumber": mobileNumber,
          };
          final result = await repository.updateProfile(
            context,
            map,
          );
          if (result.isError == false) {
          //  emit(AuthLoggedApiInState(UserResponseModel()));
          } else {
            if (isOtpVerify) {
              emit(AuthVerifyErrorState(
                  result.message ?? AppStrings.errorMessage));
            } else {
              emit(AuthErrorState(result.message ?? AppStrings.errorMessage));
            }
          }
          /* loginApiAndSaveDataToFireStore(context, token ?? "",
              isOtpVerify: isOtpVerify, phoneNumber: mobileNumber);*/
        }
      } else {
        // Handle other errors
      }
      if (isOtpVerify) {
        emit(AuthVerifyErrorState(ex.message ?? AppStrings.errorMessage));
      } else {
        emit(AuthErrorState(ex.message ?? AppStrings.errorMessage));
      }
    }
  }



  Future<void> clearGoogleSignIn() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("signInWithGoogle auth sign out exception ${e.toString()}");
    }
  }

  Future<CommonResponseModel> checkPhoneNumber(
      BuildContext context, String phoneNumber) async {
    return await repository.checkPhoneNumber(context, phoneNumber);
  }
}
