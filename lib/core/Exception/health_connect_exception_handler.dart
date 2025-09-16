import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/error_messages.dart';

enum HealthConnectErrorType {
  appNotInstalled,
  permissionDenied,
  dataNotAvailable,
  networkError,
  unknownError,
}

class HealthConnectException implements Exception {
  final HealthConnectErrorType type;
  final String message;
  final dynamic originalError;

  const HealthConnectException({
    required this.type,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'HealthConnectException: $message';
}

class HealthConnectExceptionHandler {
  static const String _healthConnectPackage = 'com.google.android.apps.healthdata';
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=$_healthConnectPackage';
  static const List<HealthDataType> _requiredTypes = [HealthDataType.STEPS];

  static Future<T> handleHealthOperation<T>({
    required Future<T> Function() operation,
    required BuildContext context,
    bool showDialog = true,
  }) async {
    try {
      return await operation();
    } catch (error) {
      final exception = mapErrorToHealthConnectException(error);
      
      if (showDialog) {
        await _showErrorDialog(context, exception);
      }
      
      rethrow;
    }
  }

  static HealthConnectException mapErrorToHealthConnectException(dynamic error) {
    if (error is HealthConnectException) {
      return error;
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('health connect') && errorString.contains('not installed')) {
      return const HealthConnectException(
        type: HealthConnectErrorType.appNotInstalled,
        message: ErrorMessages.healthConnectNotInstalled,
      );
    }

    if (errorString.contains('permission') || errorString.contains('denied')) {
      return const HealthConnectException(
        type: HealthConnectErrorType.permissionDenied,
        message: ErrorMessages.permissionsRequired,
      );
    }

    if (errorString.contains('data') || errorString.contains('no data')) {
      return const HealthConnectException(
        type: HealthConnectErrorType.dataNotAvailable,
        message: ErrorMessages.dataNotAvailable,
      );
    }

    if (errorString.contains('network') || errorString.contains('connection')) {
      return const HealthConnectException(
        type: HealthConnectErrorType.networkError,
        message: ErrorMessages.networkError,
      );
    }

    return HealthConnectException(
      type: HealthConnectErrorType.unknownError,
      message: ErrorMessages.unknownError,
      originalError: error,
    );
  }

  static Future<void> _showErrorDialog(BuildContext context, HealthConnectException exception) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getErrorTitle(exception.type)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exception.message),
                const SizedBox(height: 16),
                if (exception.type == HealthConnectErrorType.appNotInstalled ||
                    exception.type == HealthConnectErrorType.permissionDenied)
                  Text(
                    _getErrorSolution(exception.type),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          actions: _getDialogActions(context, exception.type),
        );
      },
    );
  }

  static String _getErrorTitle(HealthConnectErrorType type) {
    switch (type) {
      case HealthConnectErrorType.appNotInstalled:
        return ErrorMessages.healthConnectRequiredTitle;
      case HealthConnectErrorType.permissionDenied:
        return ErrorMessages.permissionRequiredTitle;
      case HealthConnectErrorType.dataNotAvailable:
        return ErrorMessages.dataUnavailableTitle;
      case HealthConnectErrorType.networkError:
        return ErrorMessages.connectionErrorTitle;
      case HealthConnectErrorType.unknownError:
        return ErrorMessages.errorTitle;
    }
  }

  static String _getErrorSolution(HealthConnectErrorType type) {
    switch (type) {
      case HealthConnectErrorType.appNotInstalled:
        return ErrorMessages.installHealthConnectSolution;
      case HealthConnectErrorType.permissionDenied:
        return ErrorMessages.grantPermissionsSolution;
      default:
        return '';
    }
  }

  static List<Widget> _getDialogActions(BuildContext context, HealthConnectErrorType type) {
    switch (type) {
      case HealthConnectErrorType.appNotInstalled:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(ErrorMessages.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _openPlayStore();
            },
            child: const Text(ErrorMessages.install),
          ),
        ];
      
      case HealthConnectErrorType.permissionDenied:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(ErrorMessages.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _requestPermissions();
            },
            child: const Text(ErrorMessages.grantPermission),
          ),
        ];
      
      default:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(ErrorMessages.retry),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(ErrorMessages.ok),
          ),
        ];
    }
  }

  static Future<void> _openPlayStore() async {
    final uri = Uri.parse(_playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _requestPermissions() async {
    final health = Health();
    await health.requestAuthorization(
      [HealthDataType.STEPS, HealthDataType.STEPS],
      permissions: [HealthDataAccess.READ, HealthDataAccess.WRITE],
    );
  }

  static Future<bool> isHealthConnectInstalled() async {
    try {
      final health = Health();
      await health.hasPermissions(_requiredTypes);
      return true;
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      return !errorString.contains('not installed') && !errorString.contains('health connect');
    }
  }

  static Future<bool> hasRequiredPermissions() async {
    try {
      final health = Health();
      final hasReadPermissions = await health.hasPermissions(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ],
      ) ?? false;
      
      final hasWritePermissions = await health.hasPermissions(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.WRITE],
      ) ?? false;
      
      return hasReadPermissions && hasWritePermissions;
    } catch (e) {
      return false;
    }
  }

  static HealthConnectException createAppNotInstalledException() {
    return const HealthConnectException(
      type: HealthConnectErrorType.appNotInstalled,
      message: ErrorMessages.healthConnectNotInstalled,
    );
  }

  static HealthConnectException createPermissionDeniedException() {
    return const HealthConnectException(
      type: HealthConnectErrorType.permissionDenied,
      message: ErrorMessages.permissionsRequired,
    );
  }

  static HealthConnectException createDataNotAvailableException() {
    return const HealthConnectException(
      type: HealthConnectErrorType.dataNotAvailable,
      message: ErrorMessages.dataNotAvailable,
    );
  }
}