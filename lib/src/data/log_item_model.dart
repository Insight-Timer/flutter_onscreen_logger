import 'log_item_type.dart';

/// Represents a single log item in the logger.
class LogItem {
  /// The type of the log (info, success, warning, error).
  final LogItemType type;

  /// An optional title for the log item.
  final String? title;

  /// The main content/description of the log.
  final String description;

  /// The timestamp when the log item is created.
  late final DateTime time;

  /// Creates a new log item with the specified type, description, and optional title.
  LogItem({
    required this.type,
    this.title,
    required this.description,
  }) {
    time = DateTime.now(); // Automatically sets the current time.
  }
}
