import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';
import '../models/payment_model.dart';
import '../utils/helpers.dart';
import '../widgets/status_badge.dart';

class PaymentsScreen extends StatelessWidget {
  PaymentsScreen({super.key});

  final CompanyController controller = Get.find<CompanyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments & Approvals'),
      ),
      body: Obx(() {
        final projects = controller.company.value?.projects ?? [];
        final currency = controller.company.value?.currency ?? '';
        
        List<Map<String, dynamic>> allPayments = [];
        for (var project in projects) {
          for (var payment in project.payments) {
            allPayments.add({
              'payment': payment,
              'projectName': project.name,
            });
          }
        }

        if (allPayments.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No payment records available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: allPayments.length,
          itemBuilder: (context, index) {
            final item = allPayments[index];
            final payment = item['payment'] as Payment;
            final projectName = item['projectName'] as String;
            
            return _buildPaymentCard(payment, projectName, currency);
          },
        );
      }),
    );
  }

  Widget _buildPaymentCard(Payment payment, String projectName, String currency) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: payment.approvalFlow.status == 'Approved'
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          child: Icon(
            payment.approvalFlow.status == 'Approved'
                ? Icons.check_circle
                : Icons.pending,
            color: payment.approvalFlow.status == 'Approved'
                ? Colors.green
                : Colors.orange,
          ),
        ),
        title: Text(
          'Payment ID: ${payment.paymentId}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Project: $projectName',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Requested: ${Helpers.formatDate(payment.requestDate)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Helpers.formatCurrency(payment.amount, currency),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            StatusBadge(status: payment.approvalFlow.status),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Requested By', payment.requestedBy),
                const SizedBox(height: 8),
                _buildInfoRow('Request Date', Helpers.formatDate(payment.requestDate)),
                const SizedBox(height: 8),
                _buildInfoRow('Amount', Helpers.formatCurrency(payment.amount, currency)),
                const Divider(height: 24),
                const Text(
                  'Approval Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Status', payment.approvalFlow.status),
                if (payment.approvalFlow.approvedBy.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow('Approved By', payment.approvalFlow.approvedBy),
                ],
                if (payment.approvalFlow.approvedDate.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Approved Date',
                    Helpers.formatDate(payment.approvalFlow.approvedDate),
                  ),
                ],
                if (payment.invoices.isNotEmpty) ...[
                  const Divider(height: 24),
                  const Text(
                    'Invoices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...payment.invoices.map((invoice) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                invoice.invoiceId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                Helpers.formatCurrency(invoice.amount, currency),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vendor: ${invoice.vendor}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}