import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final double toolbarHeight;
  final Function onPressed;

  const CommonAppBar(
      {required this.title,
      required this.onPressed,
      this.toolbarHeight = 60.0,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20),
      child: AppBar(
        toolbarHeight: toolbarHeight,
        /*leading: IconButton(
            icon: SvgPicture.asset(
              AppImages.backBtn,
              height: 60,
              width: 60,
            ),
            onPressed: () {
              onPressed();
            }),*/
        centerTitle: true,
        title: Text(
          title,
          /*style: Constants.textStyle(
              size: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor),*/
        ),
      ),
    );
  }
}
