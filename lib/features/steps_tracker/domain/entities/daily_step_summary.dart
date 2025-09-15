import 'package:equatable/equatable.dart';

class DailyStepSummary extends Equatable {
  final DateTime date;
  final int steps;
  final int goalSteps;
  final String dayName;

  const DailyStepSummary({
    required this.date,
    required this.steps,
    required this.goalSteps,
    required this.dayName,
  });

  double get completionPercentage => 
      goalSteps > 0 ? (steps / goalSteps * 100).clamp(0, 999) : 0;

  @override
  List<Object> get props => [date, steps, goalSteps, dayName];
}