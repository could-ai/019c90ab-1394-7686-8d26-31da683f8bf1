import 'dart:math';
import '../models/student.dart';
import '../models/course.dart';
import '../models/grade.dart';

// Simulated data representing extracted and cleaned student information
final List<Student> simulatedStudents = [
  Student(
    id: 'S001',
    name: 'Alice Johnson',
    department: 'Computer Science',
    age: 20,
    gender: 'Female',
    enrolledCourses: ['CS101', 'CS201', 'MATH101'],
    grades: {'CS101': 85.0, 'CS201': 92.0, 'MATH101': 78.0},
    hoursSpentOnLMS: 45,
  ),
  Student(
    id: 'S002',
    name: 'Bob Smith',
    department: 'Computer Science',
    age: 21,
    gender: 'Male',
    enrolledCourses: ['CS101', 'CS201', 'MATH101'],
    grades: {'CS101': 72.0, 'CS201': 68.0, 'MATH101': 55.0},
    hoursSpentOnLMS: 15,
  ),
  Student(
    id: 'S003',
    name: 'Carol Davis',
    department: 'Engineering',
    age: 19,
    gender: 'Female',
    enrolledCourses: ['ENG101', 'ENG201', 'PHYS101'],
    grades: {'ENG101': 88.0, 'ENG201': 90.0, 'PHYS101': 82.0},
    hoursSpentOnLMS: 52,
  ),
  Student(
    id: 'S004',
    name: 'David Wilson',
    department: 'Engineering',
    age: 22,
    gender: 'Male',
    enrolledCourses: ['ENG101', 'ENG201', 'PHYS101'],
    grades: {'ENG101': 45.0, 'ENG201': 52.0, 'PHYS101': 48.0},
    hoursSpentOnLMS: 12,
  ),
  // Add more simulated students as needed
];

final List<Course> simulatedCourses = [
  Course(
    id: 'CS101',
    name: 'Introduction to Programming',
    department: 'Computer Science',
    credits: 3,
    enrolledStudents: ['S001', 'S002'],
  ),
  Course(
    id: 'CS201',
    name: 'Data Structures',
    department: 'Computer Science',
    credits: 4,
    enrolledStudents: ['S001', 'S002'],
  ),
  Course(
    id: 'MATH101',
    name: 'Calculus I',
    department: 'Mathematics',
    credits: 4,
    enrolledStudents: ['S001', 'S002'],
  ),
  Course(
    id: 'ENG101',
    name: 'Engineering Principles',
    department: 'Engineering',
    credits: 3,
    enrolledStudents: ['S003', 'S004'],
  ),
  Course(
    id: 'ENG201',
    name: 'Thermodynamics',
    department: 'Engineering',
    credits: 4,
    enrolledStudents: ['S003', 'S004'],
  ),
  Course(
    id: 'PHYS101',
    name: 'Physics I',
    department: 'Physics',
    credits: 4,
    enrolledStudents: ['S003', 'S004'],
  ),
];

final List<Grade> simulatedGrades = [
  Grade(
    studentId: 'S001',
    courseId: 'CS101',
    score: 85.0,
    semester: 'Fall 2023',
    date: DateTime(2023, 12, 15),
  ),
  Grade(
    studentId: 'S001',
    courseId: 'CS201',
    score: 92.0,
    semester: 'Fall 2023',
    date: DateTime(2023, 12, 15),
  ),
  // Add more grade entries
];

// Unified data class
class SimulatedData {
  final List<Student> students;
  final List<Course> courses;
  final List<Grade> grades;

  SimulatedData({
    required this.students,
    required this.courses,
    required this.grades,
  });

  // Data cleaning: Handle missing values and normalize grades
  List<Student> get cleanedStudents {
    return students.map((student) {
      final cleanedGrades = student.grades.map((course, grade) {
        // Normalize grades to 0-100 scale if needed
        return MapEntry(course, grade.clamp(0.0, 100.0));
      });
      return Student(
        id: student.id,
        name: student.name,
        department: student.department,
        age: student.age,
        gender: student.gender,
        enrolledCourses: student.enrolledCourses,
        grades: cleanedGrades,
        hoursSpentOnLMS: student.hoursSpentOnLMS,
      );
    }).toList();
  }

  // Calculate descriptive statistics
  Map<String, double> get gradeStatistics {
    final allGrades = cleanedStudents.expand((s) => s.grades.values).toList();
    if (allGrades.isEmpty) return {};

    final sum = allGrades.reduce((a, b) => a + b);
    final mean = sum / allGrades.length;
    final sorted = List<double>.from(allGrades)..sort();
    final median = sorted.length % 2 == 0
        ? (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2
        : sorted[sorted.length ~/ 2];
    final variance = allGrades.map((g) => pow(g - mean, 2)).reduce((a, b) => a + b) / allGrades.length;
    final stdDev = sqrt(variance);

    return {
      'mean': mean,
      'median': median,
      'stdDev': stdDev,
      'min': allGrades.reduce(min),
      'max': allGrades.reduce(max),
    };
  }

  // Correlation between LMS hours and final grade
  double get correlationLMSvsGrade {
    final data = cleanedStudents.where((s) => s.grades.isNotEmpty).map((s) =>
        {'lms': s.hoursSpentOnLMS.toDouble(), 'grade': s.averageGrade}).toList();
    if (data.length < 2) return 0.0;

    final meanLMS = data.map((d) => d['lms']!).reduce((a, b) => a + b) / data.length;
    final meanGrade = data.map((d) => d['grade']!).reduce((a, b) => a + b) / data.length;

    double numerator = 0, sumSqLMS = 0, sumSqGrade = 0;
    for (var d in data) {
      final diffLMS = d['lms']! - meanLMS;
      final diffGrade = d['grade']! - meanGrade;
      numerator += diffLMS * diffGrade;
      sumSqLMS += diffLMS * diffLMS;
      sumSqGrade += diffGrade * diffGrade;
    }

    return numerator / sqrt(sumSqLMS * sumSqGrade);
  }
}

final simulatedData = SimulatedData(
  students: simulatedStudents,
  courses: simulatedCourses,
  grades: simulatedGrades,
);