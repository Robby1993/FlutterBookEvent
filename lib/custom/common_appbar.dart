import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/app_images.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final double toolbarHeight;
  final Function onPressed;
  final bool isBackBtn;

  const CommonAppBar({
    required this.title,
    required this.onPressed,
    this.isBackBtn = true,
    this.toolbarHeight = 60.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                AppImages.icBack,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Constants.textStyle(
                color: AppColors.black,
                size: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "   ",
              overflow: TextOverflow.ellipsis,
              style: Constants.textStyle(
                color: AppColors.doneColor,
                fontWeight: FontWeight.w500,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
