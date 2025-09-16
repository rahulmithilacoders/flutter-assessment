import 'dart:developer' as dev;

import 'package:health/health.dart';
import 'package:intl/intl.dart';

import '../../../../core/Exception/health_connect_exception_handler.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/daily_step_summary_model.dart';
import '../models/step_data_model.dart';

abstract class HealthDataSource {
  Future<StepDataModel?> getTodaySteps();
  Future<List<DailyStepSummaryModel>> getWeeklySteps();
  Future<bool> requestPermissions();
}

class HealthDataSourceImpl implements HealthDataSource {
  final Health health;

  HealthDataSourceImpl({required this.health});

  @override
  Future<bool> requestPermissions() async {
    try {
      final isInstalled =
          await HealthConnectExceptionHandler.isHealthConnectInstalled();
      if (!isInstalled) {
        throw HealthConnectExceptionHandler.createAppNotInstalledException();
      }

      final hasPermission =
          await HealthConnectExceptionHandler.hasRequiredPermissions();
      if (!hasPermission) {
        final granted = await health.requestAuthorization([
          HealthDataType.STEPS,
        ]);

        if (!granted) {
          throw HealthConnectExceptionHandler.createPermissionDeniedException();
        }
      }

      return true;
    } catch (e) {
      if (e is HealthConnectException) {
        rethrow;
      }

      // Handle other unexpected errors
      dev.log('Health permission request failed: $e');
      final healthException =
          HealthConnectExceptionHandler.mapErrorToHealthConnectException(e);
      throw healthException;
    }
  }

  @override
  Future<StepDataModel?> getTodaySteps() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    try {
      final healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      int totalSteps = 0;
      for (var data in healthData) {
        if (data.type == HealthDataType.STEPS) {
          totalSteps += (data.value as NumericHealthValue).numericValue.toInt();
        }
      }

      return StepDataModel(date: startOfDay, steps: totalSteps);
    } catch (e) {
      dev.log('Error getting today steps: $e');

      // Check if it's a known health connect issue
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('health connect') ||
          errorString.contains('permission')) {
        throw HealthConnectExceptionHandler.mapErrorToHealthConnectException(e);
      }

      // For other errors, return fallback data
      return StepDataModel(date: startOfDay, steps: 0);
    }
  }

  @override
  Future<List<DailyStepSummaryModel>> getWeeklySteps() async {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startDate = endDate.subtract(
      Duration(days: AppConstants.daysToShow - 1),
    );

    try {
      final healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: DateTime(startDate.year, startDate.month, startDate.day),
        endTime: endDate,
      );

      Map<String, int> dailySteps = {};

      for (var data in healthData) {
        if (data.type == HealthDataType.STEPS) {
          final dateKey = DateFormat('yyyy-MM-dd').format(data.dateFrom);
          dailySteps[dateKey] =
              (dailySteps[dateKey] ?? 0) +
              (data.value as NumericHealthValue).numericValue.toInt();
        }
      }

      List<DailyStepSummaryModel> weeklyData = [];

      for (int i = AppConstants.daysToShow - 1; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = DateFormat('yyyy-MM-dd').format(date);
        final dayName = DateFormat('EEE').format(date);
        final steps = dailySteps[dateKey] ?? 0;

        weeklyData.add(
          DailyStepSummaryModel(
            date: date,
            steps: steps,
            goalSteps: AppConstants.defaultDailyStepGoal,
            dayName: dayName,
          ),
        );
      }

      return weeklyData;
    } catch (e) {
      dev.log('Error getting weekly steps: $e');

      // Check if it's a known health connect issue
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('health connect') ||
          errorString.contains('permission')) {
        throw HealthConnectExceptionHandler.mapErrorToHealthConnectException(e);
      }

      // For other errors, return fallback data with 0 steps
      List<DailyStepSummaryModel> weeklyData = [];

      for (int i = AppConstants.daysToShow - 1; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayName = DateFormat('EEE').format(date);

        weeklyData.add(
          DailyStepSummaryModel(
            date: date,
            steps: 0,
            goalSteps: AppConstants.defaultDailyStepGoal,
            dayName: dayName,
          ),
        );
      }

      return weeklyData;
    }
  }
}
