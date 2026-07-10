class UserModel {
  final int id;
  final String name;
  final String email;
  final String college;
  final String department;
  final String semester;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.college,
    required this.department,
    required this.semester,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as int,
        name: map['name'] as String,
        email: map['email'] as String,
        college: (map['college'] ?? '') as String,
        department: (map['department'] ?? '') as String,
        semester: (map['semester'] ?? '') as String,
      );
}
