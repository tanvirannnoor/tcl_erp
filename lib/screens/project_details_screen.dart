import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';
import '../controllers/project_controller.dart';
import '../widgets/status_badge.dart';
import '../widgets/section_header.dart';
import '../widgets/info_tile.dart';
import '../utils/helpers.dart';

class ProjectDetailsScreen extends StatelessWidget {
  ProjectDetailsScreen({super.key});

  final ProjectController controller = Get.find<ProjectController>();
  final CompanyController companyController = Get.find<CompanyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
      ),
      body: Obx(() {
        final project = controller.selectedProject.value;
        if (project == null) {
          return const Center(child: Text('No project selected'));
        }

        final currency = companyController.company.value?.currency ?? '';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(status: project.status),
                  ],
                ),
              ),
              const SectionHeader(title: 'Project Information', icon: Icons.info_outline),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      InfoTile(
                        label: 'Project ID',
                        value: project.projectId,
                        icon: Icons.tag,
                      ),
                      InfoTile(
                        label: 'Start Date',
                        value: Helpers.formatDate(project.timeline.startDate),
                        icon: Icons.calendar_today,
                      ),
                      InfoTile(
                        label: 'End Date',
                        value: Helpers.formatDate(project.timeline.endDate),
                        icon: Icons.event,
                      ),
                      InfoTile(
                        label: 'Manager',
                        value: project.manager.name,
                        icon: Icons.person,
                      ),
                      InfoTile(
                        label: 'Designation',
                        value: project.manager.designation,
                        icon: Icons.badge,
                      ),
                    ],
                  ),
                ),
              ),
              const SectionHeader(title: 'Budget Breakdown', icon: Icons.account_balance_wallet),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Budget',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Helpers.formatCurrency(project.budget.total, currency),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Total Spent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Helpers.formatCurrency(project.budget.spent, currency),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...project.budget.categories.map((category) {
                        final percentage = Helpers.calculatePercentage(
                          category.spent,
                          category.allocated,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    percentage > 90 ? Colors.red : Colors.blue,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Allocated: ${Helpers.formatCurrency(category.allocated, currency)} | Spent: ${Helpers.formatCurrency(category.spent, currency)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SectionHeader(title: 'Tasks', icon: Icons.task),
              Card(
                child: project.tasks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No tasks available'),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: project.tasks.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final task = project.tasks[index];
                          return ListTile(
                            title: Text(task.title),
                            subtitle: Text('Assigned to: ${task.assignedTeam}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${task.progress}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  task.priority,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: task.priority == 'High'
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SectionHeader(title: 'Assigned Teams', icon: Icons.group),
              Card(
                child: project.teams.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No teams assigned'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: project.teams.length,
                        itemBuilder: (context, index) {
                          final team = project.teams[index];
                          return ExpansionTile(
                            title: Text(team.name),
                            subtitle: Text('${team.members.length} members'),
                            children: team.members.map((member) {
                              return ListTile(
                                dense: true,
                                leading: const Icon(Icons.person, size: 20),
                                title: Text(member.name),
                                subtitle: Text(member.role),
                              );
                            }).toList(),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}