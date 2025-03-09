import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
}