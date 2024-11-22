
import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const NoInternetWidget(
    this.onPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.toastInternetConnection,
            style: Constants.textStyle(
              color: AppColors.black,
              size: 16,
            ),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Text(
              AppStrings.btnTryAgain,
              style: Constants.textStyle(
                color: AppColors.black,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
