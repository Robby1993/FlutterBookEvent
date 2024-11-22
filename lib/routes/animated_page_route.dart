import 'package:flutter/material.dart';

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // Add your custom transition logic here
    /// Slide the new page in from the right when navigating forward
    if (animation.status == AnimationStatus.forward) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    }

    /// Slide the page out to the left when navigating backward
    else if (animation.status == AnimationStatus.reverse) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Start from right to left
          end: Offset.zero, // End at the original position
        ).animate(animation),
        child: child,
      );
    }

    /// If the animation is in any other state, just return the child
    else {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }
  }
}
