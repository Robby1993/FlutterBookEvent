import 'dart:async';
import 'package:bookmyevent/bloc/authCubit/auth_cubit.dart';
import 'package:bookmyevent/bloc/authCubit/auth_state.dart';
import 'package:bookmyevent/common_methods.dart';
import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/app_images.dart';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/custom/components.dart';
import 'package:bookmyevent/provider/internet_provider.dart';
import 'package:bookmyevent/routes/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  final Object? arguments;

  const OtpVerificationScreen({required this.arguments, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
     {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  var mobileNumber = "0";
  var verificationId = "0";

  /// resend otp timer
  int secondsRemaining = 60;
  bool enableResend = false;
  bool isLoading = false;
  late Timer timer;



  @override
  void initState() {
    if (widget.arguments != null) {
      final arg = widget.arguments as Map;
      verificationId = arg[Constants.passVerificationId];
      mobileNumber = arg[Constants.passNumber];
      debugPrint(
          "OtpVerificationScreen    verificationId $verificationId   mobileNumber : $mobileNumber");
    }
    otpTimer();
    super.initState();
   // listenForCode();
  }

  void otpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    timer.cancel();
    //cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.screenBG,
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            /*Image.asset(
              AppImages.imgTop,
            ),*/
            Stack(
              children: [
                Image.asset(
                  AppImages.imgTop,
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 0),
                ],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Verify Phone number",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enter 6 digit code sent to ${CommonMethods.maskPhoneNumber(mobileNumber)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.childLabelColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: true,
                    child: Pinput(
                      controller: pinController,
                      focusNode: focusNode,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: Constants.textStyle(
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0, // Underline thickness
                            ))
                        ),
                      ),
                      length: 6,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                        if (value.length == 6) {
                          CommonMethods.hideKeyboard();
                          /*BlocProvider.of<AuthCubit>(context)
                        .verifyOTP(
                      context,
                      mobileNumber,
                      value,
                      verificationId,
                      isOtpVerify: true,
                    );*/
                        }
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t Received Code?",
                        style: Constants.textStyle(
                            color: AppColors.textColor,
                            size: 14,
                            fontWeight: FontWeight.w400),
                        children: <InlineSpan>[
                          TextSpan(
                            text: enableResend
                                ? AppStrings.btnResendCode
                                : " $secondsRemaining sec",
                            style: Constants.textStyle(
                                color: AppColors.titleColor,
                                size: 14,
                                fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if (enableResend) {
                                  final ip = context.read<InternetProvider>();
                                  await ip.checkInternetConnection();
                                  if (ip.hasInternet == false) {
                                    CommonMethods.showSnackBar(context,
                                        AppStrings.toastInternetConnection);
                                  } else {
                                    // _resendCode();
                                    BlocProvider.of<AuthCubit>(context).sendOTP(
                                        context, mobileNumber,
                                        resend: true);
                                  }
                                }
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  phoneVerificationWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 60;
      enableResend = false;
      isLoading = false;
    });
  }

  Widget phoneVerificationWidget() {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthOtpVerifyLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is AuthLoggedApiInState) {
          hideLoader();
          CommonMethods.openScreens(context);
        } else if (state is AuthCodeReSentState) {
          hideLoader();
          verificationId = state.verificationId;
          _resendCode();
          CommonMethods.showSnackBar(context, AppStrings.toastOtpSent);
        } else if (state is AuthVerifyErrorState) {
          hideLoader();
          CommonMethods.showSnackBar(context, state.error, color: Colors.red);
        } else if (state is AuthVerifyCodeState) {
          //  pinController.text = state.otp;
          hideLoader();
        }
      },
      child: CustomButton(
        isLoading: isLoading,
        cornerRadius: 14,
        buttonText: AppStrings.btnVerify,
        onPressed: () {
          final otp = pinController.text.trim();
          if (otp.length == 6) {
            CommonMethods.hideKeyboard();
            MySharedPreferences.saveBoolData(
                MySharedPreferences.isLongedIn, true);
            context.go(Routes.homeScreenPath,);

           /* BlocProvider.of<AuthCubit>(context).verifyOTP(
              context,
              mobileNumber,
              otp,
              verificationId,
              isOtpVerify: true,
            );*/
          } else {
            CommonMethods.showSnackBar(context, AppStrings.toastEnterOtp);
          }
        },
      ),
    );
  }

  void hideLoader() {
    setState(() {
      isLoading = false;
    });
  }
}
