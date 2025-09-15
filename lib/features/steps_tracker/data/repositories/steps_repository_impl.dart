import '../../domain/entities/step_data.dart';
import '../../domain/entities/daily_step_summary.dart';
import '../../domain/repositories/steps_repository.dart';
import '../datasources/health_data_source.dart';

class StepsRepositoryImpl implements StepsRepository {
  final HealthDataSource dataSource;

  StepsRepositoryImpl({required this.dataSource});

  @override
  Future<StepData?> getTodaySteps() async {
    try {
      final stepDataModel = await dataSource.getTodaySteps();
      return stepDataModel?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<DailyStepSummary>?> getWeeklySteps() async {
    try {
      final weeklyStepsModels = await dataSource.getWeeklySteps();
      return weeklyStepsModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      return await dataSource.requestPermissions();
    } catch (e) {
      return false;
    }
  }
}