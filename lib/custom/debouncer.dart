import 'dart:async';
import 'dart:ui';

class DeBouncer {
  int? milliseconds;      // The delay time for debouncing in milliseconds
  VoidCallback? action;  // The action to be executed

  static Timer? timer;    // A static Timer instance to manage the debouncing

  static run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();   // Cancel any previous Timer instance
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,            // Schedule the action after a delay
    );
  }
}