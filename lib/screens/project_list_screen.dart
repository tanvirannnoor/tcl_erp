import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';
import '../controllers/project_controller.dart';
import '../models/project_model.dart';
import '../widgets/status_badge.dart';
import '../widgets/budget_progress.dart';
import 'project_details_screen.dart';

class ProjectListScreen extends StatelessWidget {
  ProjectListScreen({super.key});

  final CompanyController companyController = Get.find<CompanyController>();
  final ProjectController projectController = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Obx(() {
        final projects = companyController.company.value?.projects ?? [];
        
        if (projects.isEmpty) {
          return const Center(child: Text('No projects available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(context, project);
          },
        );
      }),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Card(
      child: InkWell(
        onTap: () {
          projectController.selectProject(project);
          Get.to(() => ProjectDetailsScreen());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusBadge(status: project.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    project.manager.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BudgetProgress(
                spent: project.budget.spent,
                total: project.budget.total,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget: ${companyController.company.value?.currency} ${project.budget.total ~/ 1000000}M',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Spent: ${companyController.company.value?.currency} ${project.budget.spent ~/ 1000000}M',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}