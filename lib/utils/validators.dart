import '../config/constants.dart';

class Validators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (!ValidationRules.emailRegex.hasMatch(value.trim())) {
      return ErrorMessages.invalidEmail;
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (value.length < ValidationRules.minPasswordLength) {
      return ErrorMessages.passwordTooShort;
    }
    if (value.length > ValidationRules.maxPasswordLength) {
      return 'Password must be less than ${ValidationRules.maxPasswordLength} characters.';
    }
    return null;
  }

  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (value.trim().length < ValidationRules.minNameLength) {
      return 'Name must be at least ${ValidationRules.minNameLength} characters.';
    }
    if (value.trim().length > ValidationRules.maxNameLength) {
      return 'Name must be less than ${ValidationRules.maxNameLength} characters.';
    }
    return null;
  }

  // Required Field Validation
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  // Date Validation
  static String? validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return ErrorMessages.invalidDateFormat;
    }
  }

  // Date Range Validation
  static String? validateDateRange(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) {
      return ErrorMessages.fieldRequired;
    }
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      if (end.isBefore(start)) {
        return ErrorMessages.endDateBeforeStart;
      }
      return null;
    } catch (e) {
      return ErrorMessages.invalidDateFormat;
    }
  }

  // Reason Validation
  static String? validateReason(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (value.trim().length > ValidationRules.maxReasonLength) {
      return 'Reason must be less than ${ValidationRules.maxReasonLength} characters.';
    }
    return null;
  }
}