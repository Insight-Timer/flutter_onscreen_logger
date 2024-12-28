import 'package:flutter/material.dart';

import '../data/log_item_type.dart';

///Provides extension methods on LogItemType
extension LogItemTypeExtension on LogItemType {
  ///returns the color of the log item according to it's type
  Color get itemColorByType {
    switch (this) {
      case LogItemType.info:
        return Colors.white;
      case LogItemType.warning:
        return Colors.amber;
      case LogItemType.error:
        return Colors.red;
      case LogItemType.success:
        return Colors.green;
    }
  }
}
