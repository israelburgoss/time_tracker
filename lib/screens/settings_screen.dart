import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/time_tracker_provider.dart';
import '../models/project.dart';
import '../models/task_item.dart';
import '../dialogs/add_project_dialog.dart';
import '../dialogs/add_task_dialog.dart';
import '../dialogs/confirm_delete_dialog.dart';

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
            _ProjectsTab(),
            _TasksTab(),
          ],
        ),
      ),
    );
  }
}

class _ProjectsTab extends StatelessWidget {
  const _ProjectsTab();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeTrackerProvider>(context);
    final projects = provider.projects;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => const ConfirmDeleteDialog(
                        title: 'Delete Project',
                        content: 'Are you sure you want to delete this project?',
                      ),
                    );
                    if (confirm == true) {
                      provider.deleteProject(project.id);
                    }
                  },
                ),
                onTap: () async {
                  final newName = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AddProjectDialog(initialName: project.name),
                  );
                  if (newName != null) {
                    provider.updateProject(
                      Project(id: project.id, name: newName),
                    );
                  }
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Project'),
            onPressed: () async {
              final newName = await showDialog<String>(
                context: context,
                builder: (ctx) => const AddProjectDialog(),
              );
              if (newName != null) {
                provider.addProject(
                  Project(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: newName,
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeTrackerProvider>(context);
    final tasks = provider.tasks;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => const ConfirmDeleteDialog(
                        title: 'Delete Task',
                        content: 'Are you sure you want to delete this task?',
                      ),
                    );
                    if (confirm == true) {
                      provider.deleteTask(task.id);
                    }
                  },
                ),
                onTap: () async {
                  final newName = await showDialog<String>(
                    context: context,
                    builder: (ctx) => AddTaskDialog(initialName: task.name),
                  );
                  if (newName != null) {
                    provider.updateTask(
                      TaskItem(id: task.id, name: newName),
                    );
                  }
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Task'),
            onPressed: () async {
              final newName = await showDialog<String>(
                context: context,
                builder: (ctx) => const AddTaskDialog(),
              );
              if (newName != null) {
                provider.addTask(
                  TaskItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: newName,
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
