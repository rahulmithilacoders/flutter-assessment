import '../../../../core/usecases/usecase.dart';
import '../entities/step_data.dart';
import '../repositories/steps_repository.dart';

class GetTodaySteps implements UseCase<StepData?, NoParams> {
  final StepsRepository repository;

  GetTodaySteps(this.repository);

  @override
  Future<StepData?> call(NoParams params) async {
    return await repository.getTodaySteps();
  }
}