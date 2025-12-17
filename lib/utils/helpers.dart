import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount, String currency) {
    final formatter = NumberFormat('#,##,###');
    return '$currency ${formatter.format(amount)}';
  }

  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  static double calculatePercentage(double spent, double total) {
    if (total == 0) return 0;
    return (spent / total) * 100;
  }
}