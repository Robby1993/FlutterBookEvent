import 'dart:async';

import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.isOutlined = false,
    this.outlineColor = AppColors.black,
    this.background = AppColors.btnBg,
    this.btnTextSize = 17,
    this.buttonTextColor = Colors.white,
    this.btnTextFontWeight = FontWeight.w500,
    required this.onPressed,
    this.width = 0,
    this.height = 50,
    this.svgImage = "",
    this.svgImageH = 20.0,
    this.svgImageW = 20.0,
    this.cornerRadius = 14,
    this.isGradient = true,
    this.isDisable = false,
    this.isLoading = false,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  final String buttonText;
  final Color buttonTextColor;
  final double btnTextSize;
  final FontWeight btnTextFontWeight;
  final bool isOutlined;
  final bool isGradient;
  final bool isDisable;
  final bool isLoading;
  final Color background;
  final Color outlineColor;
  final Function onPressed;
  final double width;
  final double height;
  final double cornerRadius;
  final String svgImage;
  final double svgImageH;
  final double svgImageW;
  final Duration debounceDuration;

  @override
  _DebouncedButtonState createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<CustomButton> {
  bool _isProcessing = false;
  Timer? _debounceTimer;

  void _handleTap() {
    if (_isProcessing) return;

    _isProcessing = true;
    widget.onPressed();

    _debounceTimer = Timer(widget.debounceDuration, () {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isDisable || widget.isLoading ? null : _handleTap,
      child: Stack(
        children: [
          Container(
            width: widget.width == 0
                ? MediaQuery.of(context).size.width
                : widget.width,
            height: widget.height,
            padding: const EdgeInsets.all(5),
            decoration:
                widget.isOutlined ? borderDecoration() : colorDecoration(),
            child: widget.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 4,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.svgImage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: SvgPicture.asset(
                                widget.svgImage,
                                height: widget.svgImageH,
                                width: widget.svgImageH,
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        widget.buttonText,
                        style: Constants.textStyle(
                          size: widget.btnTextSize,
                          fontWeight: widget.btnTextFontWeight,
                          color: widget.buttonTextColor,
                        ),
                      ),
                    ],
                  ),
          ),
          Visibility(
            visible: widget.isDisable,
            child: Container(
              width: widget.width == 0
                  ? MediaQuery.of(context).size.width
                  : widget.width,
              height: widget.height,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(widget.cornerRadius),
              ),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration gradientDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.0, 0.5, 1.0],
        colors: [
          /* AppColors.btn1Color,
          AppColors.btn2Color,
          AppColors.btn3Color,*/
        ],
      ),

      /*const LinearGradient(
        tileMode: TileMode.clamp,
        colors: [
          AppColors.btn1Color,
          AppColors.btn2Color,
          AppColors.btn3Color,
        ],
      ),*/
      /* border: Border.all(
          color: widget.isOutlined ? Colors.white : widget.background,
          width: 0),*/
      borderRadius: BorderRadius.circular(widget.cornerRadius),
    );
  }

  BoxDecoration colorDecoration() {
    return BoxDecoration(
      color: widget.background,
      border: Border.all(
          color: widget.isOutlined ? widget.outlineColor : widget.background,
          width: 0),
      borderRadius: BorderRadius.circular(widget.cornerRadius),
    );
  }

  BoxDecoration borderDecoration() {
    return BoxDecoration(
      color: widget.background,
      border: Border.all(color: widget.outlineColor, width: 1),
      borderRadius: BorderRadius.circular(widget.cornerRadius),
    );
  }
}
