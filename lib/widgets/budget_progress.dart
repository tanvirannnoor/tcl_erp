import 'package:flutter/material.dart';
import '../utils/helpers.dart';

class BudgetProgress extends StatelessWidget {
  final double spent;
  final double total;
  final bool showPercentage;

  const BudgetProgress({
    super.key,
    required this.spent,
    required this.total,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = Helpers.calculatePercentage(spent, total);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${percentage.toStringAsFixed(1)}% utilized',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 90 ? Colors.red : Colors.blue,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}