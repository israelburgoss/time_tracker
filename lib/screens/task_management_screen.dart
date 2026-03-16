import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/time_entry_provider.dart';
import '../models/task_item.dart';
import '../dialogs/add_task_dialog.dart';
import '../dialogs/confirm_delete_dialog.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
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
