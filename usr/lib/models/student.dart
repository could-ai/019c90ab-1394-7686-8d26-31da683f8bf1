class Student {
  final String id;
  final String name;
  final String department;
  final int age;
  final String gender;
  final List<String> enrolledCourses;
  final Map<String, double> grades;
  final int hoursSpentOnLMS;

  Student({
    required this.id,
    required this.name,
    required this.department,
    required this.age,
    required this.gender,
    required this.enrolledCourses,
    required this.grades,
    required this.hoursSpentOnLMS,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      age: json['age'],
      gender: json['gender'],
      enrolledCourses: List<String>.from(json['enrolledCourses']),
      grades: Map<String, double>.from(json['grades']),
      hoursSpentOnLMS: json['hoursSpentOnLMS'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'age': age,
      'gender': gender,
      'enrolledCourses': enrolledCourses,
      'grades': grades,
      'hoursSpentOnLMS': hoursSpentOnLMS,
    };
  }

  double get averageGrade {
    if (grades.isEmpty) return 0.0;
    return grades.values.reduce((a, b) => a + b) / grades.length;
  }

  bool get isAtRisk => averageGrade < 60.0 || hoursSpentOnLMS < 20;
}