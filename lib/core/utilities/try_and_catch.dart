import 'dart:developer';
import 'dart:ui';

class MyTryAndCatch {
  MyTryAndCatch._();

  /// The [methodName] is the name of the method where catchStack is called.
  /// The [className] is the name of the class where [methodName] is in.
  static void catchStack({
    required String methodName,
    required String className,
    required VoidCallback toTry,
  }) {
    try {
      toTry();
    } catch (e, stackTrace) {
      log(
        "There is an error occured on ${methodName} in ${className} \nThe Error is $e at $stackTrace",
      );
    }
  }
}
