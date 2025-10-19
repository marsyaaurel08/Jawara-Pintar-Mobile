class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String,
        role: m['role'] as String,
        status: m['status'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };
}
