import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/dashboard_screen.dart';
import 'package:couldai_user_app/screens/eda_screen.dart';
import 'package:couldai_user_app/screens/data_prep_screen.dart';
import 'package:couldai_user_app/screens/insights_screen.dart';

import 'models/student.dart';
import 'models/course.dart';
import 'models/grade.dart';
import 'data/simulated_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Performance Analytics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/data_prep': (context) => DataPrepScreen(data: simulatedData),
        '/eda': (context) => EDAScreen(data: simulatedData),
        '/dashboard': (context) => DashboardScreen(data: simulatedData),
        '/insights': (context) => InsightsScreen(data: simulatedData),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Performance Analytics'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Interactive Data Analytics and Visualization',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/data_prep'),
              child: const Text('Phase 1: Data Preparation'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/eda'),
              child: const Text('Phase 2: Exploratory Data Analysis'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/dashboard'),
              child: const Text('Phase 3: Interactive Dashboard'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/insights'),
              child: const Text('Phase 4: Insights & Reporting'),
            ),
          ],
        ),
      ),
    );
  }
}