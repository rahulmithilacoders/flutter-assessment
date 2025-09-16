import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/bloc_error_handler.dart';
import '../../domain/usecases/get_today_steps.dart';
import '../../domain/usecases/get_weekly_steps.dart';
import '../../domain/usecases/request_health_permissions.dart';
import 'steps_tracker_event.dart';
import 'steps_tracker_state.dart';

class StepsTrackerBloc extends Bloc<StepsTrackerEvent, StepsTrackerState> {
  final GetTodaySteps getTodaySteps;
  final GetWeeklySteps getWeeklySteps;
  final RequestHealthPermissions requestHealthPermissions;

  StepsTrackerBloc({
    required this.getTodaySteps,
    required this.getWeeklySteps,
    required this.requestHealthPermissions,
  }) : super(StepsTrackerInitial()) {
    on<LoadStepsDataEvent>(_onLoadStepsData);
    on<RefreshStepsDataEvent>(_onRefreshStepsData);
    on<RequestPermissionsEvent>(_onRequestPermissions);
  }

  Future<void> _onLoadStepsData(
    LoadStepsDataEvent event,
    Emitter<StepsTrackerState> emit,
  ) async {
    emit(StepsTrackerLoading());
    await _loadData(emit);
  }

  Future<void> _onRefreshStepsData(
    RefreshStepsDataEvent event,
    Emitter<StepsTrackerState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _onRequestPermissions(
    RequestPermissionsEvent event,
    Emitter<StepsTrackerState> emit,
  ) async {
    try {
      final hasPermission = await requestHealthPermissions(NoParams());
      if (hasPermission) {
        add(LoadStepsDataEvent());
      } else {
        emit(
          const StepsTrackerPermissionDenied(
            message: 'Health permissions are required to track steps',
          ),
        );
      }
    } catch (e) {
      emit(BlocErrorHandler.handleError(e));
    }
  }

  Future<void> _loadData(Emitter<StepsTrackerState> emit) async {
    try {
      final todayStepsResult = await getTodaySteps(NoParams());
      final weeklyStepsResult = await getWeeklySteps(NoParams());

      emit(
        StepsTrackerLoaded(
          todaySteps: todayStepsResult,
          weeklySteps: weeklyStepsResult,
        ),
      );
    } catch (e) {
      emit(BlocErrorHandler.handleError(e));
    }
  }
}
