import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Exception/health_connect_exception_handler.dart';
import '../../../../core/constants/error_messages.dart';
import '../bloc/steps_tracker_bloc.dart';
import '../bloc/steps_tracker_event.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback onRetry;
  final String? subtitle;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
    required this.onRetry,
    this.subtitle,
  });

  factory ErrorStateWidget.generic({
    required String message,
    required VoidCallback onRetry,
  }) {
    return ErrorStateWidget(
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      buttonText: ErrorMessages.retry,
      onRetry: onRetry,
    );
  }

  factory ErrorStateWidget.healthConnect({
    required String message,
    required HealthConnectErrorType errorType,
    required VoidCallback onRetry,
  }) {
    return ErrorStateWidget(
      message: message,
      icon: errorType == HealthConnectErrorType.appNotInstalled
          ? Icons.download
          : Icons.error,
      iconColor: Colors.orange,
      buttonText: errorType == HealthConnectErrorType.appNotInstalled
          ? ErrorMessages.install
          : ErrorMessages.retry,
      onRetry: onRetry,
    );
  }

  factory ErrorStateWidget.permissionDenied({
    required String message,
    required VoidCallback onRetry,
  }) {
    return ErrorStateWidget(
      message: message,
      icon: Icons.security,
      iconColor: Colors.orange,
      buttonText: ErrorMessages.grantPermission,
      onRetry: onRetry,
      subtitle: ErrorMessages.androidHealthNote,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: iconColor),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}

// Extension to create error widgets from BLoC context
extension ErrorStateHelper on BuildContext {
  Widget buildErrorState(String message) {
    return ErrorStateWidget.generic(
      message: 'Error: $message',
      onRetry: () => read<StepsTrackerBloc>().add(LoadStepsDataEvent()),
    );
  }

  Widget buildHealthConnectErrorState(
    String message,
    HealthConnectErrorType errorType,
  ) {
    return ErrorStateWidget.healthConnect(
      message: message,
      errorType: errorType,
      onRetry: () => read<StepsTrackerBloc>().add(RequestPermissionsEvent()),
    );
  }

  Widget buildPermissionDeniedState(String message) {
    return ErrorStateWidget.permissionDenied(
      message: message,
      onRetry: () => read<StepsTrackerBloc>().add(RequestPermissionsEvent()),
    );
  }
}
