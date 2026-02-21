import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String formatDate() {
    return DateFormat('MMM dd, yyyy hh:mm aa').format(this);
  }
}
