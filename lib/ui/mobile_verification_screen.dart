import 'dart:ui';
import 'package:bookmyevent/bloc/authCubit/auth_cubit.dart';
import 'package:bookmyevent/bloc/authCubit/auth_state.dart';
import 'package:bookmyevent/common_methods.dart';
import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/app_images.dart';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:bookmyevent/core/my_share_preference.dart';
import 'package:bookmyevent/custom/components.dart';
import 'package:bookmyevent/routes/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class MobileVerificationScreen extends StatefulWidget {
  const MobileVerificationScreen({super.key});

  @override
  State<MobileVerificationScreen> createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  var fullNumber = "";
 // var countryCode = "US";
  PhoneNumber? phoneNumber;
  final ValueNotifier<bool> isButtonLoader = ValueNotifier<bool>(false);
  // late Future<String> _futureData;

  @override
  void initState() {
    super.initState();
   // getCountryCode();
    // _futureData = CommonMethods.getCountryPhoneCode(context);
  }

  void getCountryCode() {
   // countryCode = PlatformDispatcher.instance.locale.countryCode ?? "US";
  //  debugPrint("systemCountryCode    $countryCode");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBG,
      body: ValueListenableBuilder<bool>(
        valueListenable: isButtonLoader,
        builder: (context, value, _) {
          return IgnorePointer(
            ignoring: isButtonLoader.value,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Image.asset(
                  AppImages.imgTop,
                ),
                Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.labelVerificationPhone,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Enter your mobile number to get OTP for verification",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.childLabelColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      phoneEditText("+91"),
                     /* FutureBuilder<String?>(
                        future: _futureData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          } else {
                            if (snapshot.hasError) {
                              return const SizedBox.shrink();
                            } else {
                              return phoneEditText(snapshot.data ?? "US");
                            }
                          }
                        },
                      ),*/
                      const SizedBox(
                        height: 30,
                      ),
                      btnVerifyWidget(),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: true,
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: "Back to",
                              style: Constants.textStyle(
                                  color: AppColors.textColor,
                                  size: 14,
                                  fontWeight: FontWeight.w700),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${AppStrings.btnSignIn}',
                                  style: Constants.textStyle(
                                    color: AppColors.titleColor,
                                    size: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      CommonMethods.logoutAndClearSession(
                                        context,
                                      );
                                    },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget phoneEditText(String countyCode) {
    return IntlPhoneField(
      textAlignVertical: TextAlignVertical.center,
      // Align text vertically
      dropdownIconPosition: IconPosition.trailing,
      showDropdownIcon: true,
      disableLengthCheck: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // flagsButtonPadding: const EdgeInsets.only(left: 10),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      // Only numbers can be entered
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        // contentPadding: EdgeInsets.symmetric(vertical: 0),
        isDense: true,
        counterText: '',
        border: InputBorder.none,
        hintText: AppStrings.hintMobileNo,

        hintStyle: Constants.textStyle(
          color: AppColors.hintColor,
          size: 14,
          fontWeight: FontWeight.w400,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      initialCountryCode: countyCode,
      onChanged: (phone) {
        phoneNumber = phone;
        fullNumber = phone.completeNumber;
        debugPrint("onChanged fullNumber:  $fullNumber");
      },
      onCountryChanged: (country) {
        if (phoneNumber != null) {
          phoneNumber = PhoneNumber(
            countryCode: "+${country.dialCode}",
            number: phoneNumber!.number,
            countryISOCode: '',
          );
          fullNumber = phoneNumber!.completeNumber;
        }
      },
    );
  }

  Widget btnVerifyWidget() {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthLoadingState) {
            isButtonLoader.value = true;
          } else if (state is AuthCodeSentState) {
            isButtonLoader.value = false;
            context.pushNamed(
              Routes.otpVerificationScreenName,
              extra: {
                Constants.passNumber: fullNumber,
                Constants.passVerificationId: state.verificationId,
              },
            );
          } else if (state is AuthLoggedApiInState) {

            isButtonLoader.value = false;

            CommonMethods.openScreens(context);
          } else if (state is AuthErrorState) {
            if (state.error.isNotEmpty) {
              CommonMethods.showSnackBar(context, state.error);
            }
            isButtonLoader.value = false;
          } else if (state is AuthTimeOutErrorState) {
            isButtonLoader.value = false;
            CommonMethods.showSnackBar(context, state.error);
          }
        },
        child: CustomButton(
          buttonText: AppStrings.btnGetCode,
          cornerRadius: 14,
          isLoading: isButtonLoader.value,
          onPressed: () async {

            context.pushNamed(
              Routes.otpVerificationScreenName,
              extra: {
                Constants.passNumber: fullNumber,
                Constants.passVerificationId: "0",
              },
            );


           /* final ip = context.read<InternetProvider>();
            await ip.checkInternetConnection();
            if (ip.hasInternet == false) {
              CommonMethods.showSnackBar(
                  context, AppStrings.toastInternetConnection);
            } else {
              bool isNumberValidate = false;
              try {
                isNumberValidate = phoneNumber!.isValidNumber();
                debugPrint(
                    "onChanged validator: $phoneNumber  $isNumberValidate");
              } catch (e) {
                isNumberValidate = false;
                debugPrint(
                    "onChanged validator $phoneNumber Exception ${e.toString()}");
              }
              if (fullNumber.isEmpty || phoneNumber == null) {
                CommonMethods.hideKeyboard();
                CommonMethods.showSnackBar(
                    context, AppStrings.toastEnterPhoneNumber);
              }
              else {
                String fullNumber = phoneNumber?.completeNumber ?? "";
                debugPrint("btnVerify fullNumber:  $fullNumber");
                CommonMethods.hideKeyboard();
                context.read<AuthCubit>().sendOTP(context, fullNumber);
              }
            }*/
          },
        ));
  }
}
