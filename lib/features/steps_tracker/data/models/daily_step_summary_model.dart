import '../../domain/entities/daily_step_summary.dart';

class DailyStepSummaryModel extends DailyStepSummary {
  const DailyStepSummaryModel({
    required super.date,
    required super.steps,
    required super.goalSteps,
    required super.dayName,
  });

  factory DailyStepSummaryModel.fromEntity(DailyStepSummary summary) {
    return DailyStepSummaryModel(
      date: summary.date,
      steps: summary.steps,
      goalSteps: summary.goalSteps,
      dayName: summary.dayName,
    );
  }

  DailyStepSummary toEntity() {
    return DailyStepSummary(
      date: date,
      steps: steps,
      goalSteps: goalSteps,
      dayName: dayName,
    );
  }
}