import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomUiDialog(
    BuildContext context, {
    required String title,
    required Widget contentWidget,
    double borderRadius = 10.0,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(24),
    bool barrierDismissible = false,
    Color backgroundColor =  Colors.white,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: contentPadding,
          surfaceTintColor: Colors.transparent,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          //this right here
          title: title.isNotEmpty
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Constants.textStyle(
                    color: AppColors.textColor,
                    size: 20,
                  ),
                )
              : null,
          content: contentWidget,
        );
      },
    );
  }

  static void openBottomSheetDialog(
    BuildContext context, {
    required Widget contentWidget,
    isScrollControlled = true,
    isDismissible = false,
    showDragHandle = false,
    marginEdgeInsets = const EdgeInsets.all(8),
    useSafeArea = false,
  }) {
    showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minWidth: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                margin: marginEdgeInsets,
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: SafeArea(child: contentWidget),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void timePickerDialog(
      BuildContext context, DateTime time, Function(DateTime) callback) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 220,
          decoration: const BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 0),
            ],
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(top: 8.0),
          //  color: Colors.black,
          child: CupertinoDatePicker(
              initialDateTime: time,
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              // This is called when the user changes the time.
              onDateTimeChanged: (DateTime newTime) => callback),
        );
      },
    );
  }

  static void showAlertDialog(BuildContext context, String message) {
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        // BlocProvider.of<NetworkCubit>(context).observeNetwork();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
