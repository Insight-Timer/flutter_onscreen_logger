import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/log_item_model.dart';
import 'data/log_item_type.dart';
import 'logger_overlay/controllers/logger_overlay_controller.dart';

/// This class provides an interface for logging messages to an on-screen logger.
class OnScreenLog {
  OnScreenLog._internal(); // Private constructor to prevent instantiation

  static LoggerOverlayController get _loggerController {
    if (!Get.isRegistered<LoggerOverlayController>()) {
      Get.put(LoggerOverlayController());
    }
    return Get.find();
  }

  /// Sets up error handling to log Flutter errors automatically.
  ///
  /// This method replaces the default error widget builder and
  /// `FlutterError.onError` to log uncaught Flutter exceptions to the logger.
  static void onError() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      _onFlutterException(errorDetails);
      return const Center(
          child: Text('An error occurred. Check logs for details.'));
    };

    FlutterError.onError = _onFlutterException;
  }

  /// Handles Flutter exceptions and logs them as error messages.
  ///
  /// This is used internally by the `onError` method to process and log
  /// uncaught Flutter errors.
  static void _onFlutterException(FlutterErrorDetails errorDetails) {
    try {
      Timer(
        const Duration(milliseconds: 100),
        () => _loggerController.log(
          LogItem(
            type: LogItemType.error,
            title: errorDetails.exception.toString(),
            description: errorDetails.stack.toString(),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error logging exception to ScreenLog: ${e.toString()}');
    }
  }

  /// Logs an informational message.
  ///
  /// - [title]: Optional title for the log message.
  /// - [message]: The content of the log message.
  static void i({String? title, required String message}) =>
      _log(LogItemType.info, title, message);

  /// Logs a success message.
  ///
  /// - [title]: Optional title for the log message.
  /// - [message]: The content of the log message.
  static void s({String? title, required String message}) =>
      _log(LogItemType.success, title, message);

  /// Logs an error message.
  ///
  /// - [title]: Optional title for the log message.
  /// - [message]: The content of the log message.
  static void e({String? title, required String message}) =>
      _log(LogItemType.error, title, message);

  /// Logs a warning message.
  ///
  /// - [title]: Optional title for the log message.
  /// - [message]: The content of the log message.
  static void w({String? title, required String message}) =>
      _log(LogItemType.warning, title, message);

  /// Shares all logged messages.
  ///
  /// This method saves the current log messages and opens the sharing interface
  /// so the user can share the logs.
  static void shareAll() => _loggerController.saveAndShareLogItems();

  /// Clears all logged messages.
  ///
  /// This method removes all log entries currently stored in the logger.
  static void clearAll() => _loggerController.clearAll();

  /// Helper method to log messages of various types.
  ///
  /// - [type]: The type of log item (info, success, error, warning).
  /// - [title]: Optional title for the log message.
  /// - [message]: The content of the log message.
  static void _log(LogItemType type, String? title, String message) {
    _loggerController.log(
      LogItem(
        type: type,
        title: title,
        description: message,
      ),
    );
  }
}
