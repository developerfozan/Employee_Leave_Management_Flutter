import 'package:intl/intl.dart';
import '../config/constants.dart';

class DateHelper {
  // Format date for display
  static String formatForDisplay(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat(DateFormats.display).format(dateTime);
    } catch (e) {
      return date;
    }
  }

  // Format date for API
  static String formatForApi(DateTime date) {
    return DateFormat(DateFormats.api).format(date);
  }

  // Parse date from API
  static DateTime? parseFromApi(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  // Calculate days between dates
  static int daysBetween(String startDate, String endDate) {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return end.difference(start).inDays + 1; // +1 to include both start and end dates
    } catch (e) {
      return 0;
    }
  }

  // Check if date is in the past
  static bool isInPast(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return dateTime.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  // Get today's date in API format
  static String getTodayApi() {
    return formatForApi(DateTime.now());
  }
}