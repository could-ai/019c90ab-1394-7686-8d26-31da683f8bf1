import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/simulated_data.dart';

class InsightsScreen extends StatelessWidget {
  final SimulatedData data;

  const InsightsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final atRiskStudents = data.cleanedStudents.where((s) => s.isAtRisk).toList();
    final departmentStats = _calculateDepartmentStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 4: Insights & Reporting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predictive Insights',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Early Warning System',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('At-Risk Students Identified: ${atRiskStudents.length}'),
                    const Text('• Students with average grade < 60'),
                    const Text('• Students with LMS hours < 20'),
                    const SizedBox(height: 16),
                    const Text('Recommended Interventions:'),
                    const Text('• Academic counseling sessions'),
                    const Text('• Increased LMS engagement monitoring'),
                    const Text('• Tutoring program enrollment'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Department Performance Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final depts = departmentStats.keys.toList();
                          if (value.toInt() < depts.length) {
                            return Text(depts[value.toInt()], style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: departmentStats.entries.map((entry) {
                    return BarChartGroupData(
                      x: departmentStats.keys.toList().indexOf(entry.key),
                      barRods: [
                        BarChartRodData(toY: entry.value['avg']!, color: Colors.blue),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Key Findings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Strong correlation between LMS engagement and academic performance'),
                    Text('• Computer Science department shows highest average grades'),
                    Text('• Engineering students have highest LMS usage'),
                    Text('• Early intervention can prevent academic failure'),
                    Text('• Department-specific support programs recommended'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recommendations for Educational Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. Implement automated early warning systems'),
                    Text('2. Increase LMS engagement monitoring and support'),
                    Text('3. Develop department-specific intervention strategies'),
                    Text('4. Regular progress tracking and feedback sessions'),
                    Text('5. Enhanced tutoring and academic support programs'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, double>> _calculateDepartmentStats() {
    final stats = <String, Map<String, double>>{};
    final departments = data.cleanedStudents.map((s) => s.department).toSet();

    for (var dept in departments) {
      final deptStudents = data.cleanedStudents.where((s) => s.department == dept).toList();
      if (deptStudents.isEmpty) continue;

      final avgGrade = deptStudents.map((s) => s.averageGrade).reduce((a, b) => a + b) / deptStudents.length;
      final avgLMS = deptStudents.map((s) => s.hoursSpentOnLMS).reduce((a, b) => a + b) / deptStudents.length;
      final atRiskCount = deptStudents.where((s) => s.isAtRisk).length;

      stats[dept] = {
        'avg': avgGrade,
        'lms': avgLMS,
        'atRisk': atRiskCount.toDouble(),
      };
    }

    return stats;
  }
}