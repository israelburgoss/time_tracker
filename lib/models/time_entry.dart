class TimeEntry {
  final Object id;
  final Object projectId;
  final Object taskId;
  final int durationMinutes;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.durationMinutes,
    required this.date,
    required this.notes,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      durationMinutes: json['durationMinutes'],
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'durationMinutes': durationMinutes,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
