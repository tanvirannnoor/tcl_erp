import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';
import '../models/task_model.dart';
import '../widgets/section_header.dart';

class TaskTeamScreen extends StatelessWidget {
  TaskTeamScreen({super.key});

  final CompanyController controller = Get.find<CompanyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks & Teams'),
      ),
      body: Obx(() {
        final projects = controller.company.value?.projects ?? [];
        
        List<Task> allTasks = [];
        for (var project in projects) {
          allTasks.addAll(project.tasks);
        }

        if (allTasks.isEmpty) {
          return const Center(child: Text('No tasks available'));
        }

        final completedTasks = allTasks.where((t) => t.progress == 100).toList();
        final inProgressTasks = allTasks.where((t) => t.progress > 0 && t.progress < 100).toList();
        final pendingTasks = allTasks.where((t) => t.progress == 0).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (completedTasks.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Completed Tasks',
                  icon: Icons.check_circle,
                ),
                ...completedTasks.map((task) => _buildTaskCard(task, Colors.green)),
              ],
              if (inProgressTasks.isNotEmpty) ...[
                const SectionHeader(
                  title: 'In Progress Tasks',
                  icon: Icons.pending,
                ),
                ...inProgressTasks.map((task) => _buildTaskCard(task, Colors.blue)),
              ],
              if (pendingTasks.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Pending Tasks',
                  icon: Icons.schedule,
                ),
                ...pendingTasks.map((task) => _buildTaskCard(task, Colors.orange)),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTaskCard(Task task, Color statusColor) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.task, color: statusColor, size: 20),
        ),
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.group,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  task.assignedTeam,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: task.priority == 'High'
                    ? Colors.red.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                task.priority,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: task.priority == 'High' ? Colors.red : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${task.progress}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Progress: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: task.progress / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${task.progress}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (task.subTasks.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Sub Tasks:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...task.subTasks.map((subTask) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            subTask.status == 'Completed'
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: subTask.status == 'Completed'
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            subTask.title,
                            style: TextStyle(
                              fontSize: 13,
                              decoration: subTask.status == 'Completed'
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}