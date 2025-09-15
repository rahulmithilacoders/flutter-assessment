import 'package:equatable/equatable.dart';
import '../../domain/entities/step_data.dart';
import '../../domain/entities/daily_step_summary.dart';

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

  const StepsTrackerLoaded({
    this.todaySteps,
    this.weeklySteps,
  });

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