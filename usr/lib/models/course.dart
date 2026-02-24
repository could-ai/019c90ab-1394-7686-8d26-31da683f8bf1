class Course {
  final String id;
  final String name;
  final String department;
  final int credits;
  final List<String> enrolledStudents;

  Course({
    required this.id,
    required this.name,
    required this.department,
    required this.credits,
    required this.enrolledStudents,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      credits: json['credits'],
      enrolledStudents: List<String>.from(json['enrolledStudents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'credits': credits,
      'enrolledStudents': enrolledStudents,
    };
  }
}