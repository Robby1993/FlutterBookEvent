import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then(
        (_) => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
      );

  static void hide(BuildContext context) => context.pop();

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("LoadingDialog-------------------------");
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            color: Colors.transparent,
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
