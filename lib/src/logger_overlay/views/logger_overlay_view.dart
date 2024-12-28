import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/logger_overlay_controller.dart';
import 'logger_list_item.dart';

/// A widget that provides an on-screen logger overlay with options to view, share, or clear logs.
class LoggerOverlayWidget extends StatelessWidget {
  late final LoggerOverlayController _controller;

  /// Initializes the logger overlay controller using GetX.
  /// If the controller is not registered, it will be created and registered.
  LoggerOverlayWidget({super.key}) {
    if (Get.isRegistered<LoggerOverlayController>()) {
      _controller = Get.find();
    } else {
      _controller = Get.put(LoggerOverlayController());
    }
  }

  /// Builds the main logger overlay widget.
  /// It uses `Obx` to dynamically update the UI based on the controller's state.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // Always LTR as logs are in English.
      child: Obx(
        () => Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLogToggleButton(),
              // Toggle button for the logger overlay.
              if (_controller.isExpanded.value) _buildLoggerView(),
              // Logger view.
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the detailed logger view with log entries and action buttons.
  Widget _buildLoggerView() {
    return Expanded(
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              const Text(
                'OnScreen Logger', // Logger title.
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  controller: _controller.listViewScrollController,
                  itemCount: _controller.logItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LoggerListItem(index: index); // Displays a log item.
                  },
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    text: 'Share All', // Share button.
                    icon: Icons.share,
                    color: Colors.green[500]!,
                    onPressed: _controller.saveAndShareLogItems,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    text: 'Clear All', // Clear button.
                    icon: Icons.delete_outline_rounded,
                    color: Colors.red,
                    onPressed: _controller.clearAll,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an action button with a custom text, icon, and color.
  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required Function() onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.pressed)
              ? Colors.black // Pressed color.
              : color, // Default color.
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.pressed)
              ? color // Pressed color.
              : Colors.black, // Default color.
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (states) => states.contains(WidgetState.pressed)
              ? const BorderSide(
                  width: 2, color: Colors.black) // Pressed border.
              : BorderSide(width: 2, color: color), // Default border.
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 16), // Button icon.
            const SizedBox(width: 8),
            Text(text), // Button text.
          ],
        ),
      ),
    );
  }

  /// Builds the toggle button to expand or collapse the logger overlay.
  Widget _buildLogToggleButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(400),
          bottomLeft: Radius.circular(400),
        ),
        child: GestureDetector(
          onTap: _controller.toggleOverlay, // Toggle overlay state.
          child: Container(
            height: 45,
            width: 45,
            color: Get.theme.primaryColor,
            child: const Center(
              child: Icon(
                Icons.list, // Icon for the toggle button.
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
