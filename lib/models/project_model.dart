import 'budget_model.dart';
import 'task_model.dart';
import 'payment_model.dart';

class Project {
  final String projectId;
  final String name;
  final String status;
  final Timeline timeline;
  final Manager manager;
  final List<Team> teams;
  final Budget budget;
  final List<Task> tasks;
  final List<Payment> payments;
  final List<Risk> risks;

  Project({
    required this.projectId,
    required this.name,
    required this.status,
    required this.timeline,
    required this.manager,
    required this.teams,
    required this.budget,
    required this.tasks,
    required this.payments,
    required this.risks,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      timeline: Timeline.fromJson(json['timeline'] ?? {}),
      manager: Manager.fromJson(json['manager'] ?? {}),
      teams: (json['teams'] as List?)?.map((t) => Team.fromJson(t)).toList() ?? [],
      budget: Budget.fromJson(json['budget'] ?? {}),
      tasks: (json['tasks'] as List?)?.map((t) => Task.fromJson(t)).toList() ?? [],
      payments: (json['payments'] as List?)?.map((p) => Payment.fromJson(p)).toList() ?? [],
      risks: (json['risks'] as List?)?.map((r) => Risk.fromJson(r)).toList() ?? [],
    );
  }
}

class Timeline {
  final String startDate;
  final String endDate;
  final List<Milestone> milestones;

  Timeline({
    required this.startDate,
    required this.endDate,
    required this.milestones,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      milestones: (json['milestones'] as List?)
              ?.map((m) => Milestone.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Milestone {
  final String milestoneId;
  final String title;
  final String status;

  Milestone({
    required this.milestoneId,
    required this.title,
    required this.status,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      milestoneId: json['milestoneId'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Manager {
  final String employeeId;
  final String name;
  final String designation;
  final String email;

  Manager({
    required this.employeeId,
    required this.name,
    required this.designation,
    required this.email,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      employeeId: json['employeeId'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Team {
  final String teamId;
  final String name;
  final List<Member> members;

  Team({
    required this.teamId,
    required this.name,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'] ?? '',
      name: json['name'] ?? '',
      members: (json['members'] as List?)
              ?.map((m) => Member.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Member {
  final String name;
  final String role;

  Member({
    required this.name,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class Risk {
  final String riskId;
  final String description;
  final String severity;
  final String mitigation;

  Risk({
    required this.riskId,
    required this.description,
    required this.severity,
    required this.mitigation,
  });

  factory Risk.fromJson(Map<String, dynamic> json) {
    return Risk(
      riskId: json['riskId'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? '',
      mitigation: json['mitigation'] ?? '',
    );
  }
}