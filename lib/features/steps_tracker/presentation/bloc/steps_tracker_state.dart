import 'package:equatable/equatable.dart';

import '../../../../core/health_connect/health_connect_exception_handler.dart';
import '../../domain/entities/daily_step_summary.dart';
import '../../domain/entities/step_data.dart';

abstract class StepsTrackerState extends Equatable {
  const StepsTrackerState();

  @override
  List<Object?> get props => [];
}

class StepsTrackerInitial extends StepsTrackerState {}

class StepsTrackerLoading extends StepsTrackerState {}

class StepsTrackerLoaded extends StepsTrackerState {
  final StepData? todaySteps;
  final List<DailyStepSummary>? weeklySteps;

  const StepsTrackerLoaded({this.todaySteps, this.weeklySteps});

  @override
  List<Object?> get props => [todaySteps, weeklySteps];
}

class StepsTrackerError extends StepsTrackerState {
  final String message;

  const StepsTrackerError({required this.message});

  @override
  List<Object> get props => [message];
}

class StepsTrackerPermissionDenied extends StepsTrackerState {
  final String message;

  const StepsTrackerPermissionDenied({required this.message});

  @override
  List<Object> get props => [message];
}

class StepsTrackerHealthConnectError extends StepsTrackerState {
  final String message;
  final HealthConnectErrorType errorType;

  const StepsTrackerHealthConnectError({
    required this.message,
    required this.errorType,
  });

  @override
  List<Object> get props => [message, errorType];
}
