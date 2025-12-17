import 'package:get/get.dart';
import '../models/company_model.dart';
import '../services/json_service.dart';

class CompanyController extends GetxController {
  final JsonService _jsonService = JsonService();

  final Rx<Company?> company = Rx<Company?>(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _jsonService.loadCompanyData();
      company.value = data;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  double get totalBudget {
    return company.value?.projects.fold(
          0.0,
          (sum, project) => sum! + project.budget.total,
        ) ??
        0.0;
  }

  double get totalSpent {
    return company.value?.projects.fold(
          0.0,
          (sum, project) => sum! + project.budget.spent,
        ) ??
        0.0;
  }

  int get totalTasks {
    return company.value?.projects.fold(
          0,
          (sum, project) => sum! + project.tasks.length,
        ) ??
        0;
  }

  int get pendingApprovals {
    int count = 0;
    company.value?.projects.forEach((project) {
      count +=
          project.payments
              .where((p) => p.approvalFlow.status == 'Pending')
              .length;
    });
    return count;
  }
}
