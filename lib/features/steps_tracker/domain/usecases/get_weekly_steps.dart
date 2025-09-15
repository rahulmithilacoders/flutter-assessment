import '../../../../core/usecases/usecase.dart';
import '../entities/daily_step_summary.dart';
import '../repositories/steps_repository.dart';

class GetWeeklySteps implements UseCase<List<DailyStepSummary>?, NoParams> {
  final StepsRepository repository;

  GetWeeklySteps(this.repository);

  @override
  Future<List<DailyStepSummary>?> call(NoParams params) async {
    return await repository.getWeeklySteps();
  }
}