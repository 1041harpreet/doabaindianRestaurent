import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

showErrorToast({message,context}) {
  showToast(
    message,
    context: context,
    backgroundColor: Colors.red,
    textStyle: const TextStyle(fontSize: 14, color: Colors.white),
    animation: StyledToastAnimation.slideFromTop,
    reverseAnimation: StyledToastAnimation.fadeScale,
    position: StyledToastPosition.top,
    animDuration: const Duration(milliseconds: 200),
    duration: const Duration(seconds: 5),
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeOutCubic,
  );
}

showSuccessToast({message,context}) {
  showToast(
    message,
    context: context,
    backgroundColor: Colors.green,
    textStyle: const TextStyle(fontSize: 14, color: Colors.white),
    animation: StyledToastAnimation.slideFromTop,
    reverseAnimation: StyledToastAnimation.fadeScale,
    position: StyledToastPosition.top,
    animDuration: const Duration(milliseconds: 200),
    duration: const Duration(seconds: 5),
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeOutCubic,
  );
}
