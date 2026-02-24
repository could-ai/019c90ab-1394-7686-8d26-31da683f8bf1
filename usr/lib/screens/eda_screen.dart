import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/simulated_data.dart';

class EDAScreen extends StatelessWidget {
  final SimulatedData data;

  const EDAScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final stats = data.gradeStatistics;
    final correlation = data.correlationLMSvsGrade;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 2: Exploratory Data Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descriptive Statistics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Mean Grade: ${stats['mean']?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('Median Grade: ${stats['median']?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('Standard Deviation: ${stats['stdDev']?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('Min Grade: ${stats['min']?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('Max Grade: ${stats['max']?.toStringAsFixed(2) ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Grade Distribution Histogram',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0: return const Text('0-20');
                            case 1: return const Text('21-40');
                            case 2: return const Text('41-60');
                            case 3: return const Text('61-80');
                            case 4: return const Text('81-100');
                            default: return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  barGroups: _createHistogramData(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Correlation Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Correlation between LMS Hours and Final Grade: ${correlation.toStringAsFixed(3)}'),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ScatterChart(
                ScatterChartData(
                  scatterSpots: data.cleanedStudents.map((student) {
                    return ScatterSpot(
                      student.hoursSpentOnLMS.toDouble(),
                      student.averageGrade,
                    );
                  }).toList(),
                  minX: 0,
                  maxX: 80,
                  minY: 0,
                  maxY: 100,
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _createHistogramData() {
    final bins = [0, 20, 40, 60, 80, 100];
    final counts = List<int>.filled(bins.length - 1, 0);

    for (var student in data.cleanedStudents) {
      for (var grade in student.grades.values) {
        for (int i = 0; i < bins.length - 1; i++) {
          if (grade >= bins[i] && grade < bins[i + 1]) {
            counts[i]++;
            break;
          }
        }
      }
    }

    return counts.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue),
        ],
      );
    }).toList();
  }
}