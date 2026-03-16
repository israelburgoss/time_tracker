import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/time_entry_provider.dart';
import '../models/project.dart';
import '../dialogs/add_project_dialog.dart';
import '../dialogs/confirm_delete_dialog.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
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
