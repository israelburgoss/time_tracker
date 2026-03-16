import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import '../provider/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
import 'settings_screen.dart';
import '../models/time_entry.dart';
import '../dialogs/confirm_delete_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          if (provider.entries.isEmpty) {
            return const Center(child: Text('No time entries yet.'));
          }

          // Group entries by projectId
          final groupedEntries = groupBy(provider.entries, (TimeEntry e) => e.projectId);

          return ListView.builder(
            itemCount: groupedEntries.keys.length,
            itemBuilder: (context, index) {
              final projectId = groupedEntries.keys.elementAt(index);
              final projectEntries = groupedEntries[projectId]!;
              final project = provider.projects.firstWhereOrNull((p) => p.id == projectId);
              final projectName = project?.name ?? 'Unknown Project';

              final totalProjectMinutes = projectEntries.fold<int>(0, (sum, item) => sum + item.durationMinutes);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    projectName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Total Time: ${_formatDuration(totalProjectMinutes)}'),
                  initiallyExpanded: true,
                  children: projectEntries.map((entry) {
                    final task = provider.tasks.firstWhereOrNull((t) => t.id == entry.taskId);
                    final taskName = task?.name ?? 'Unknown Task';
                    final dateStr = DateFormat.yMMMd().format(entry.date);

                    return ListTile(
                      title: Text(taskName),
                      subtitle: Text('$dateStr\n${entry.notes}'),
                      isThreeLine: entry.notes.isNotEmpty,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatDuration(entry.durationMinutes),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => const ConfirmDeleteDialog(
                                  title: 'Delete Entry',
                                  content: 'Are you sure you want to delete this time entry?',
                                ),
                              );
                              if (confirm == true) {
                                provider.deleteTimeEntry(entry.id);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTimeEntryScreen()),
          );
        },
      ),
    );
  }
}
