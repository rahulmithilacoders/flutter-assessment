import '../../../../core/usecases/usecase.dart';
import '../repositories/steps_repository.dart';

class RequestHealthPermissions implements UseCase<bool, NoParams> {
  final StepsRepository repository;

  RequestHealthPermissions(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    return await repository.requestPermissions();
  }
}