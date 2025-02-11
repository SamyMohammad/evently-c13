import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  return dateFormat.format(date);
}

String formatTime(DateTime time) {
  DateFormat dateFormat = DateFormat("hh:mm a");
  return dateFormat.format(time);
}

String getMonthNameFromDate(DateTime dateTime) {
  DateFormat dateFormat = DateFormat("MMM");
  return dateFormat.format(dateTime);
}
