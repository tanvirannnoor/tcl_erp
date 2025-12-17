import 'package:get/get.dart';
import '../models/project_model.dart';

class ProjectController extends GetxController {
  final Rx<Project?> selectedProject = Rx<Project?>(null);

  void selectProject(Project project) {
    selectedProject.value = project;
  }
}