import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/log_item_model.dart';
import 'data/log_item_type.dart';
import 'logger_overlay/controllers/logger_overlay_controller.dart';

/// This class provides an interface for logging messages to an on-screen logger.
/// It has been marked as [Deprecated] and should be replaced with [ScreenLog].
///
/// Use this class to log messages, handle Flutter errors, or initialize the logger overlay.
@Deprecated('Use ScreenLog instead!')
class OnscreenLogger {
  /// Private constructor to prevent instantiation.
  /// This class uses static methods and cannot be instantiated directly.
  OnscreenLogger._();

  /// Initializes the `LoggerOverlayController` and injects it into the `GetX` dependency system.
  ///
  /// This method must be called before using any other functionality of the class.
  static void init() {
    Get.put(LoggerOverlayController());
  }

  /// Configures global error handling for Flutter errors.
  ///
  /// This method intercepts Flutter's error reporting mechanisms and logs the errors
  /// to the on-screen logger. It modifies both the `ErrorWidget.builder` and
  /// `FlutterError.onError` to handle errors.
  static void onError() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      _onFlutterException(errorDetails);
      return Container();
    };

    FlutterError.onError = _onFlutterException;
  }

  /// Internal method for handling Flutter exceptions and logging them as errors.
  ///
  /// This method is automatically invoked when a Flutter exception occurs
  /// and logs the error details, including the stack trace, to the logger.
  ///
  /// - [errorDetails]: Contains details about the Flutter error.
  static void _onFlutterException(FlutterErrorDetails errorDetails) {
    try {
      final LoggerOverlayController logController = Get.find();
      Timer(
        const Duration(milliseconds: 100),
        () => logController.log(
          LogItem(
            type: LogItemType.error,
            title: errorDetails.exception.toString(),
            description:
                errorDetails.stack != null ? errorDetails.stack.toString() : '',
          ),
        ),
      );
    } catch (e) {
      debugPrint('cant log error into lexzur debugger: $e');
    }
  }

  /// Logs a custom [LogItem] to the on-screen logger.
  ///
  /// This method can be used to log messages of various types (info, error, success, etc.)
  /// directly to the logger overlay.
  ///
  /// - [logItem]: The log item to be displayed in the logger overlay.
  static void log(LogItem logItem) {
    final LoggerOverlayController logController = Get.find();
    logController.log(logItem);
  }
}
