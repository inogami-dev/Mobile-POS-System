import 'dart:developer';

class MyLogger {
  MyLogger._(); // Private constructor to prevent instantiation

  static void logError({
    required String errorLabel,
    required Object errorMessage,
    StackTrace? stackTrace,
  }) {
    if (stackTrace == null) {
      log("❌ $errorLabel: $errorMessage");
    } else {
      log("$errorLabel: $errorMessage at:\n$stackTrace");
    }
  }

  static void success({String? successLabel, String? successMessage}) {
    if (successLabel != null && successMessage != null) {
      log("$successLabel: $successMessage");
    } else {
      log("Success!");
    }
  }
}
