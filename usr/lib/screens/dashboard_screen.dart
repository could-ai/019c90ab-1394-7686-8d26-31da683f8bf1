import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/simulated_data.dart';
import '../models/student.dart';

class DashboardScreen extends StatefulWidget {
  final SimulatedData data;

  const DashboardScreen({super.key, required this.data});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Student? selectedStudent;

  @override
  Widget build(BuildContext context) {
    final atRiskStudents = widget.data.cleanedStudents.where((s) => s.isAtRisk).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 3: Interactive Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Performance Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Students'),
                          Text(
                            '${widget.data.students.length}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('At-Risk Students'),
                          Text(
                            '${atRiskStudents.length}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Performance Heatmap',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _buildHeatmap(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Student List (Click for Details)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data.cleanedStudents.length,
              itemBuilder: (context, index) {
                final student = widget.data.cleanedStudents[index];
                return Card(
                  color: student.isAtRisk ? Colors.red.shade50 : null,
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Text('Avg Grade: ${student.averageGrade.toStringAsFixed(1)} | LMS Hours: ${student.hoursSpentOnLMS}'),
                    trailing: Icon(
                      student.isAtRisk ? Icons.warning : Icons.check_circle,
                      color: student.isAtRisk ? Colors.red : Colors.green,
                    ),
                    onTap: () {
                      setState(() {
                        selectedStudent = student;
                      });
                    },
                  ),
                );
              },
            ),
            if (selectedStudent != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Student Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${selectedStudent!.name}'),
                      Text('ID: ${selectedStudent!.id}'),
                      Text('Department: ${selectedStudent!.department}'),
                      Text('Age: ${selectedStudent!.age}'),
                      Text('Gender: ${selectedStudent!.gender}'),
                      Text('LMS Hours: ${selectedStudent!.hoursSpentOnLMS}'),
                      const SizedBox(height: 16),
                      const Text('Grades:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...selectedStudent!.grades.entries.map((entry) =>
                        Text('${entry.key}: ${entry.value.toStringAsFixed(1)}')
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap() {
    // Simplified heatmap representation using a grid of colored containers
    final departments = ['Computer Science', 'Engineering', 'Mathematics', 'Physics'];
    final gradeRanges = ['0-50', '51-70', '71-85', '86-100'];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: departments.length * gradeRanges.length,
      itemBuilder: (context, index) {
        final deptIndex = index ~/ gradeRanges.length;
        final gradeIndex = index % gradeRanges.length;
        final dept = departments[deptIndex];
        final gradeRange = gradeRanges[gradeIndex];

        // Calculate intensity based on student data
        final studentsInDept = widget.data.cleanedStudents.where((s) => s.department == dept);
        final studentsInRange = studentsInDept.where((s) {
          final avg = s.averageGrade;
          switch (gradeIndex) {
            case 0: return avg >= 0 && avg <= 50;
            case 1: return avg > 50 && avg <= 70;
            case 2: return avg > 70 && avg <= 85;
            case 3: return avg > 85 && avg <= 100;
            default: return false;
          }
        }).length;

        final intensity = studentsInDept.isEmpty ? 0.0 : studentsInRange / studentsInDept.length;
        final color = Color.lerp(Colors.red, Colors.green, intensity)!;

        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '$dept\n$gradeRange\n${(intensity * 100).toStringAsFixed(0)}%',
              style: const TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}