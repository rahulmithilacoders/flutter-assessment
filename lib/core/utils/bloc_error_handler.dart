import '../health_connect/health_connect_exception_handler.dart';
import '../../features/steps_tracker/presentation/bloc/steps_tracker_state.dart';

class BlocErrorHandler {
  static StepsTrackerState handleError(dynamic error) {
    if (error is HealthConnectException) {
      switch (error.type) {
        case HealthConnectErrorType.appNotInstalled:
          return StepsTrackerHealthConnectError(
            message: error.message,
            errorType: error.type,
          );
        case HealthConnectErrorType.permissionDenied:
          return const StepsTrackerPermissionDenied(
            message: 'Health permissions are required to track steps',
          );
        default:
          return StepsTrackerError(message: error.message);
      }
    }
    return StepsTrackerError(message: error.toString());
  }
}