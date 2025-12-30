class UserModel {
  final String id;
  final String name;
  final String email;
  final String department;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      isAdmin: json['is_admin']?.toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'is_admin': isAdmin ? '1' : '0',
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? department,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}