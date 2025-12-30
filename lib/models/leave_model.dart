class LeaveModel {
  final String id;
  final String employeeId;
  final String? employeeName;
  final String? department;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;

  LeaveModel({
    required this.id,
    required this.employeeId,
    this.employeeName,
    this.department,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id']?.toString() ?? '',
      employeeId: json['employee_id']?.toString() ?? '',
      employeeName: json['name']?.toString(),
      department: json['department']?.toString(),
      leaveType: json['leave_type']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'name': employeeName,
      'department': department,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'status': status,
    };
  }

  LeaveModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? department,
    String? leaveType,
    String? startDate,
    String? endDate,
    String? reason,
    String? status,
  }) {
    return LeaveModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      department: department ?? this.department,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}