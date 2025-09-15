import 'package:health/health.dart';
import 'package:intl/intl.dart';
import '../models/step_data_model.dart';
import '../models/daily_step_summary_model.dart';
import '../../../../core/constants/app_constants.dart';

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
    final types = [HealthDataType.STEPS];
    
    try {
      bool hasPermission = await health.hasPermissions(types) ?? false;
      
      if (!hasPermission) {
        hasPermission = await health.requestAuthorization(types);
      }
      
      return hasPermission;
    } catch (e) {
      // On Android, if Google Fit is not available, we might get an error
      // In this case, we can try to proceed anyway as the error might be about
      // the permission launcher, but step counting could still work
      // ignore: avoid_print
      print('Health permission request failed: $e');
      return true; // Allow the app to continue and try to get data
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

      return StepDataModel(
        date: startOfDay,
        steps: totalSteps,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error getting today steps: $e');
      // Return a model with 0 steps instead of null to show the UI
      return StepDataModel(
        date: startOfDay,
        steps: 0,
      );
    }
  }

  @override
  Future<List<DailyStepSummaryModel>> getWeeklySteps() async {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startDate = endDate.subtract(Duration(days: AppConstants.daysToShow - 1));

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
          dailySteps[dateKey] = (dailySteps[dateKey] ?? 0) + 
              (data.value as NumericHealthValue).numericValue.toInt();
        }
      }

      List<DailyStepSummaryModel> weeklyData = [];
      
      for (int i = AppConstants.daysToShow - 1; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = DateFormat('yyyy-MM-dd').format(date);
        final dayName = DateFormat('EEE').format(date);
        final steps = dailySteps[dateKey] ?? 0;

        weeklyData.add(DailyStepSummaryModel(
          date: date,
          steps: steps,
          goalSteps: AppConstants.defaultDailyStepGoal,
          dayName: dayName,
        ));
      }

      return weeklyData;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting weekly steps: $e');
      // Return empty list with current week dates and 0 steps
      List<DailyStepSummaryModel> weeklyData = [];
      
      for (int i = AppConstants.daysToShow - 1; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayName = DateFormat('EEE').format(date);

        weeklyData.add(DailyStepSummaryModel(
          date: date,
          steps: 0,
          goalSteps: AppConstants.defaultDailyStepGoal,
          dayName: dayName,
        ));
      }

      return weeklyData;
    }
  }
}