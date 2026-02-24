class Grade {
  final String studentId;
  final String courseId;
  final double score;
  final String semester;
  final DateTime date;

  Grade({
    required this.studentId,
    required this.courseId,
    required this.score,
    required this.semester,
    required this.date,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      studentId: json['studentId'],
      courseId: json['courseId'],
      score: json['score'],
      semester: json['semester'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'score': score,
      'semester': semester,
      'date': date.toIso8601String(),
    };
  }
}