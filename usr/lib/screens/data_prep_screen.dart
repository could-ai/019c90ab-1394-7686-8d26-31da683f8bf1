import 'package:flutter/material.dart';
import '../data/simulated_data.dart';

class DataPrepScreen extends StatelessWidget {
  final SimulatedData data;

  const DataPrepScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 1: Data Preparation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Collection and Integration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Total Students: ${data.students.length}'),
            Text('Total Courses: ${data.courses.length}'),
            Text('Total Grade Records: ${data.grades.length}'),
            const SizedBox(height: 24),
            const Text(
              'Data Cleaning Results',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('• Handled missing values'),
            const Text('• Removed duplicates'),
            const Text('• Normalized grading scales'),
            const SizedBox(height: 24),
            const Text(
              'Cleaned Student Data Sample',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Avg Grade')),
              ],
              rows: data.cleanedStudents.take(5).map((student) {
                return DataRow(cells: [
                  DataCell(Text(student.id)),
                  DataCell(Text(student.name)),
                  DataCell(Text(student.department)),
                  DataCell(Text(student.averageGrade.toStringAsFixed(1))),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}