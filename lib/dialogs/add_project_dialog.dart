import 'package:flutter/material.dart';

class AddProjectDialog extends StatefulWidget {
  final String? initialName;
  const AddProjectDialog({super.key, this.initialName});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Add Project' : 'Edit Project'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Project Name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.trim().isNotEmpty) {
              Navigator.of(context).pop(_nameController.text.trim());
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
