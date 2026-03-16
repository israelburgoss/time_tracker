import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/project.dart';
import '../models/task_item.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<TaskItem> _tasks = [];
  List<TimeEntry> _entries = [];

  List<Project> get projects => _projects;
  List<TaskItem> get tasks => _tasks;
  List<TimeEntry> get entries => _entries;

  TimeEntryProvider() {
    _loadData();
  }

  void _loadData() {
    final projectsJson = localStorage.getItem('projects');
    if (projectsJson != null) {
      final List decoded = jsonDecode(projectsJson);
      _projects = decoded.map((e) => Project.fromJson(e)).toList();
    }

    final tasksJson = localStorage.getItem('tasks');
    if (tasksJson != null) {
      final List decoded = jsonDecode(tasksJson);
      _tasks = decoded.map((e) => TaskItem.fromJson(e)).toList();
    }

    final entriesJson = localStorage.getItem('entries');
    if (entriesJson != null) {
      final List decoded = jsonDecode(entriesJson);
      _entries = decoded.map((e) => TimeEntry.fromJson(e)).toList();
    }
    notifyListeners();
  }

  void _saveData() {
    localStorage.setItem('projects', jsonEncode(_projects.map((e) => e.toJson()).toList()));
    localStorage.setItem('tasks', jsonEncode(_tasks.map((e) => e.toJson()).toList()));
    localStorage.setItem('entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  // --- Projects ---
  void addProject(Project project) {
    _projects.add(project);
    _saveData();
    notifyListeners();
  }

  void updateProject(Project project) {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      _saveData();
      notifyListeners();
    }
  }

  void deleteProject(Object id) {
    _projects.removeWhere((p) => p.id == id);
    // Optionally delete associated time entries or keep them
    // _entries.removeWhere((e) => e.projectId == id);
    _saveData();
    notifyListeners();
  }

  // --- Tasks ---
  void addTask(TaskItem task) {
    _tasks.add(task);
    _saveData();
    notifyListeners();
  }

  void updateTask(TaskItem task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _saveData();
      notifyListeners();
    }
  }

  void deleteTask(Object id) {
    _tasks.removeWhere((t) => t.id == id);
    // _entries.removeWhere((e) => e.taskId == id);
    _saveData();
    notifyListeners();
  }

  // --- Time Entries ---
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveData();
    notifyListeners();
  }
  
  void deleteTimeEntry(Object id) {
    _entries.removeWhere((e) => e.id == id);
    _saveData();
    notifyListeners();
  }
}
