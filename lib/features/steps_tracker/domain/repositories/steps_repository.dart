import '../entities/step_data.dart';
import '../entities/daily_step_summary.dart';

abstract class StepsRepository {
  Future<StepData?> getTodaySteps();
  Future<List<DailyStepSummary>?> getWeeklySteps();
  Future<bool> requestPermissions();
}