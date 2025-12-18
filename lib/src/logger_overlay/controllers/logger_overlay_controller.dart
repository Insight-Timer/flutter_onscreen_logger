import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onscreen_logger/src/extensions/date_extension.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/log_item_model.dart';

/// Controller for the logging overlay
class LoggerOverlayController extends GetxController {
  /// Controls the visibility of the logger overlay (expanded/collapsed).
  final RxBool isExpanded = false.obs;

  /// List of log items displayed in the logger.
  final RxList<LogItem> logItems = <LogItem>[].obs;

  /// Tracks the expansion state of each log item (expanded/collapsed).
  final RxList<bool> logItemsExpansionState = <bool>[].obs;

  /// Scroll controller for the list view of log items.
  final ScrollController listViewScrollController = ScrollController();

  /// Toggles the visibility of the logger overlay.
  /// Scrolls to the bottom if the overlay is expanded.
  void toggleOverlay() {
    isExpanded.value = !isExpanded.value;
    if (isExpanded.value) {
      Timer(const Duration(milliseconds: 100), scrollToBottom);
    }
  }

  /// Toggles the expansion state of a specific log item.
  /// [index] - The index of the log item in the list.
  void toggleItemExpansion(int index) {
    final bool originalValue = logItemsExpansionState[index];
    logItemsExpansionState.removeAt(index); // Remove the old state.
    logItemsExpansionState.insert(
        index, !originalValue); // Insert the toggled state.
  }

  /// Copies log item details to the clipboard and shows a toast message.
  /// [item] - The log item to copy.
  void copyErrorInfo(LogItem item) {
    Clipboard.setData(
      ClipboardData(
        text:
            'Type: ${item.type.name}\n\n${item.title}\n\n${item.description}\n\n${item.time}',
      ),
    );

    // Show a toast indicating the log info has been copied.
    Fluttertoast.showToast(
      msg: 'Log info copied to clipboard!',
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );
  }

  /// Adds a new log item to the log and scrolls to the bottom.
  /// [item] - The log item to add.
  void log(LogItem item) {
    logItems.add(item); // Add log item.
    logItemsExpansionState.add(false); // Add expansion state.
    scrollToBottom(); // Scroll to the bottom.
  }

  /// Scrolls to the bottom of the log list after the layout is built.
  /// A delay is used to ensure the new item is rendered before scrolling.
  void scrollToBottom() {
    if (listViewScrollController.hasClients) {
      Timer(const Duration(milliseconds: 400), () {
        listViewScrollController.position.animateTo(
          listViewScrollController.position.maxScrollExtent,
          // Scroll to the end.
          duration: const Duration(milliseconds: 200),
          curve:
              Curves.elasticOut, // Apply an elastic curve for smooth scrolling.
        );
      });
    }
  }

  /// Clears all log items from the list.
  void clearAll() => logItems.clear();

  /// Saves the current log items to a file and shares them.
  Future<void> saveAndShareLogItems() async {
    try {
      String content = _saveLogItems(); // Prepare the log content.
      await _shareLogItems(fileContent: content); // Share the log file.
    } catch (e) {
      debugPrint('Error saving or sharing log items: $e');
    }
  }

  /// Creates a file with the log items' content and shares it.
  /// [fileContent] - The content to write to the file.
  Future<void> _shareLogItems({required String fileContent}) async {
    final tempDir = await getTemporaryDirectory(); // Get the temp directory.
    final filePath =
        '${tempDir.path}/log_report.txt'; // File path for the report.
    final file = File(filePath);

    await file.writeAsString(fileContent); // Write content to the file.

    if (await file.exists()) {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: "Here's the log report!",
        sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100),
      );
    }
  }

  /// Prepares a string representation of all log items to be saved and shared.
  String _saveLogItems() {
    final shareDate =
        DateTime.now().getDateTimeAsLoggingString(); // Get current date.

    String content = '';
    content += 'Date of Sharing: $shareDate\n'; // Add date to content.
    content +=
        '\n-------------------------------------------------------------------------------\n\n';

    // Format log items as strings and join them together.
    content += logItems.map((item) {
      return """
Type: ${item.type.toString().split('.').last}\n
Title: ${item.title}\n
${item.description}\n
Time: ${item.time.getDateTimeAsLoggingString()}\n
-------------------------------------------------------------------------------
          """;
    }).join('\n');
    return content;
  }
}
