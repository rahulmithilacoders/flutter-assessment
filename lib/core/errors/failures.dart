import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class HealthDataFailure extends Failure {
  final String message;

  const HealthDataFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PermissionFailure extends Failure {
  final String message;

  const PermissionFailure(this.message);

  @override
  List<Object> get props => [message];
}