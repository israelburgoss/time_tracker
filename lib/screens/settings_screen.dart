import 'package:flutter/material.dart';
import 'project_management_screen.dart';
import 'task_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Projects'),
              Tab(text: 'Tasks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProjectManagementScreen(),
            TaskManagementScreen(),
          ],
        ),
      ),
    );
  }
}
