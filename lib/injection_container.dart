import 'package:get_it/get_it.dart';
import 'package:health/health.dart';

import 'features/steps_tracker/data/datasources/health_data_source.dart';
import 'features/steps_tracker/data/repositories/steps_repository_impl.dart';
import 'features/steps_tracker/domain/repositories/steps_repository.dart';
import 'features/steps_tracker/domain/usecases/get_today_steps.dart';
import 'features/steps_tracker/domain/usecases/get_weekly_steps.dart';
import 'features/steps_tracker/domain/usecases/request_health_permissions.dart';
import 'features/steps_tracker/presentation/bloc/steps_tracker_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Steps Tracker
  // BLoC
  sl.registerFactory(
    () => StepsTrackerBloc(
      getTodaySteps: sl(),
      getWeeklySteps: sl(),
      requestHealthPermissions: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodaySteps(sl()));
  sl.registerLazySingleton(() => GetWeeklySteps(sl()));
  sl.registerLazySingleton(() => RequestHealthPermissions(sl()));

  // Repository
  sl.registerLazySingleton<StepsRepository>(
    () => StepsRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HealthDataSource>(
    () => HealthDataSourceImpl(health: sl()),
  );

  // External
  sl.registerLazySingleton(() => Health());
}