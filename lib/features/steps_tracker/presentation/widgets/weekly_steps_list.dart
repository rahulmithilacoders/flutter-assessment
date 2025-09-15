import 'package:flutter/material.dart';
import '../../domain/entities/daily_step_summary.dart';

class WeeklyStepsList extends StatelessWidget {
  final List<DailyStepSummary> weeklySteps;

  const WeeklyStepsList({
    super.key,
    required this.weeklySteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last 7 days',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...weeklySteps.map((summary) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  summary.dayName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${summary.steps.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} (${summary.completionPercentage.toStringAsFixed(summary.completionPercentage % 1 == 0 ? 0 : 1)}%)',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}