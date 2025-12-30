import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../core/exceptions/app_exception.dart';
import '../models/user_model.dart';
import '../models/leave_model.dart';

class ApiService {
  // Helper method to handle API responses
  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return data;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(data['message'] ?? 'Unauthorized access');
      } else if (response.statusCode >= 500) {
        throw ServerException(data['message'] ?? 'Server error occurred');
      } else {
        throw AppException(data['message'] ?? 'An error occurred');
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Invalid response from server');
    }
  }

  // Helper method to make POST requests
  static Future<Map<String, dynamic>> _post(String endpoint, Map<String, String> body) async {
    try {
      final response = await http
          .post(
        Uri.parse('${AppConfig.baseUrl}$endpoint'),
        body: body,
      )
          .timeout(AppConfig.apiTimeout);

      return await _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on http.ClientException {
      throw NetworkException('Failed to connect to server');
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('An unexpected error occurred');
    }
  }

  // Helper method to make GET requests
  static Future<Map<String, dynamic>> _get(String endpoint, {Map<String, String>? params}) async {
    try {
      Uri uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      if (params != null && params.isNotEmpty) {
        uri = uri.replace(queryParameters: params);
      }

      final response = await http
          .get(uri)
          .timeout(AppConfig.apiTimeout);

      return await _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on http.ClientException {
      throw NetworkException('Failed to connect to server');
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('An unexpected error occurred');
    }
  }

  // Login API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _post(AppConfig.loginEndpoint, {
      'email': email.trim(),
      'password': password,
    });

    if (response['success'] == true && response['data'] != null) {
      return {
        'success': true,
        'user': UserModel.fromJson(response['data']),
        'message': response['message'] ?? 'Login successful',
      };
    } else {
      return {
        'success': false,
        'message': response['message'] ?? 'Login failed',
      };
    }
  }

  // Add Employee API
  static Future<Map<String, dynamic>> addEmployee({
    required String name,
    required String email,
    required String password,
    required String department,
  }) async {
    final response = await _post(AppConfig.addEmployeeEndpoint, {
      'action': 'add',
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'department': department.trim(),
    });

    return {
      'success': response['success'] == true,
      'message': response['message'] ?? 'Operation completed',
    };
  }

  // Apply Leave API
  static Future<Map<String, dynamic>> applyLeave({
    required String employeeId,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    final response = await _post(AppConfig.applyLeaveEndpoint, {
      'employee_id': employeeId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason.trim(),
    });

    return {
      'success': response['success'] == true,
      'message': response['message'] ?? 'Operation completed',
    };
  }

  // Get Leaves API
  static Future<List<LeaveModel>> getLeaves({String? employeeId}) async {
    final params = employeeId != null ? {'employee_id': employeeId} : null;
    final response = await _get(AppConfig.getLeavesEndpoint, params: params);

    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((json) => LeaveModel.fromJson(json)).toList();
    }
    return [];
  }

  // Update Leave Status API
  static Future<Map<String, dynamic>> updateLeaveStatus({
    required String leaveId,
    required String status,
  }) async {
    final response = await _post(AppConfig.updateLeaveStatusEndpoint, {
      'leave_id': leaveId,
      'status': status,
    });

    return {
      'success': response['success'] == true,
      'message': response['message'] ?? 'Operation completed',
    };
  }
}