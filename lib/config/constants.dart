// Environment Configuration for XAMPP
class AppConfig {
  // API Configuration for XAMPP
  // For Android Emulator: use 10.0.2.2
  // For Physical Device: use your PC's local IP (e.g., 192.168.1.100)
  // For iOS Simulator: use 127.0.0.1 or localhost
  static const String baseUrl = 'http://10.0.2.2/elms_php';

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // API Endpoints
  static const String loginEndpoint = '/login.php';
  static const String addEmployeeEndpoint = '/employees_crud.php';
  static const String applyLeaveEndpoint = '/apply_leave.php';
  static const String getLeavesEndpoint = '/get_leaves.php';
  static const String updateLeaveStatusEndpoint = '/update_leave_status.php';
}

// Leave Types
class LeaveTypes {
  static const String sick = 'Sick Leave';
  static const String casual = 'Casual Leave';
  static const String annual = 'Annual Leave';
  static const String unpaid = 'Unpaid Leave';
  static const String maternity = 'Maternity Leave';
  static const String paternity = 'Paternity Leave';

  static List<String> get all => [sick, casual, annual, unpaid, maternity, paternity];
}

// Leave Status
class LeaveStatus {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String rejected = 'rejected';

  static List<String> get all => [pending, approved, rejected];
}

// Validation Constants
class ValidationRules {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int maxReasonLength = 500;

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
}

// Error Messages
class ErrorMessages {
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String passwordTooShort = 'Password must be at least 6 characters.';
  static const String fieldRequired = 'This field is required.';
  static const String invalidDateFormat = 'Invalid date format.';
  static const String endDateBeforeStart = 'End date must be after start date.';
  static const String unauthorized = 'Unauthorized access.';
}

// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'Login successful!';
  static const String employeeAdded = 'Employee added successfully!';
  static const String leaveApplied = 'Leave application submitted successfully!';
  static const String leaveApproved = 'Leave approved successfully!';
  static const String leaveRejected = 'Leave rejected successfully!';
}

// Date Formats
class DateFormats {
  static const String display = 'dd MMM yyyy';
  static const String api = 'yyyy-MM-dd';
  static const String displayWithTime = 'dd MMM yyyy, hh:mm a';
}

// App Info
class AppInfo {
  static const String appName = 'Employee Leave Management System';
  static const String version = '1.0.0';
}