import 'package:equatable/equatable.dart';

abstract class StepsTrackerEvent extends Equatable {
  const StepsTrackerEvent();

  @override
  List<Object> get props => [];
}

class LoadStepsDataEvent extends StepsTrackerEvent {}

class RefreshStepsDataEvent extends StepsTrackerEvent {}

class RequestPermissionsEvent extends StepsTrackerEvent {}