import '../../../../core/usecases/usecase.dart';
import '../repositories/steps_repository.dart';

class WriteMockStepsData implements UseCase<bool, NoParams> {
  final StepsRepository repository;

  WriteMockStepsData(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return await repository.writeMockStepsData();
  }
}