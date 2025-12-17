class Task {
  final String taskId;
  final String title;
  final String assignedTeam;
  final String priority;
  final int progress;
  final List<SubTask> subTasks;
  final List<ActivityLog> activityLogs;

  Task({
    required this.taskId,
    required this.title,
    required this.assignedTeam,
    required this.priority,
    required this.progress,
    required this.subTasks,
    required this.activityLogs,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'] ?? '',
      title: json['title'] ?? '',
      assignedTeam: json['assignedTeam'] ?? '',
      priority: json['priority'] ?? '',
      progress: json['progress'] ?? 0,
      subTasks: (json['subTasks'] as List?)
              ?.map((s) => SubTask.fromJson(s))
              .toList() ??
          [],
      activityLogs: (json['activityLogs'] as List?)
              ?.map((a) => ActivityLog.fromJson(a))
              .toList() ??
          [],
    );
  }

  String get status {
    if (progress == 100) return 'Completed';
    if (progress > 0) return 'In Progress';
    return 'Pending';
  }
}

class SubTask {
  final String subTaskId;
  final String title;
  final String status;

  SubTask({
    required this.subTaskId,
    required this.title,
    required this.status,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      subTaskId: json['subTaskId'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ActivityLog {
  final String date;
  final String updatedBy;
  final String remark;

  ActivityLog({
    required this.date,
    required this.updatedBy,
    required this.remark,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      date: json['date'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      remark: json['remark'] ?? '',
    );
  }
}