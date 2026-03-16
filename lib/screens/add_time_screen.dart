import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/time_tracker_provider.dart';
import '../models/time_entry.dart';
import '../models/project.dart';
import '../models/task_item.dart';

class AddTimeScreen extends StatefulWidget {
  const AddTimeScreen({super.key});

  @override
  State<AddTimeScreen> createState() => _AddTimeScreenState();
}

class _AddTimeScreenState extends State<AddTimeScreen> {
  final _formKey = GlobalKey<FormState>();

  Object? _selectedProjectId;
  Object? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();
  int _durationMinutes = 0;
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      if (_selectedProjectId == null || _selectedTaskId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both a Project and a Task.')),
        );
        return;
      }

      final provider = Provider.of<TimeTrackerProvider>(context, listen: false);
      final newEntry = TimeEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // simple unique id generator
        projectId: _selectedProjectId!,
        taskId: _selectedTaskId!,
        durationMinutes: _durationMinutes,
        date: _selectedDate,
        notes: _notesController.text.trim(),
      );

      provider.addTimeEntry(newEntry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeTrackerProvider>(context);
    final projects = provider.projects;
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Object>(
                value: _selectedProjectId,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: projects.map((Project p) {
                  return DropdownMenuItem<Object>(
                    value: p.id,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedProjectId = val;
                  });
                },
                validator: (val) => val == null ? 'Please select a project' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Object>(
                value: _selectedTaskId,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  border: OutlineInputBorder(),
                ),
                items: tasks.map((TaskItem t) {
                  return DropdownMenuItem<Object>(
                    value: t.id,
                    child: Text(t.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedTaskId = val;
                  });
                },
                validator: (val) => val == null ? 'Please select a task' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (in minutes)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter duration';
                  }
                  final parsed = int.tryParse(val);
                  if (parsed == null || parsed <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  _durationMinutes = parsed;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Entry', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
