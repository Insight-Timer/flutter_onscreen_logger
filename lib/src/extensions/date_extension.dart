import 'package:intl/intl.dart';

///Provides extension methods on DateTime
extension DateExtension on DateTime {
  ///formats the date time used for the log items into the following format HH:mm:ss - dd/MM/yyyy
  String getDateTimeAsLoggingString() =>
      DateFormat('HH:mm:ss - dd/MM/yyyy').format(this);
}
