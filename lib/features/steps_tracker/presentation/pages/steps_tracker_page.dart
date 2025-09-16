import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Exception/health_connect_exception_handler.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../bloc/steps_tracker_bloc.dart';
import '../bloc/steps_tracker_event.dart';
import '../bloc/steps_tracker_state.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/steps_progress_bar.dart';
import '../widgets/weekly_steps_list.dart';

class StepsTrackerPage extends StatelessWidget {
  const StepsTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StepsTrackerBloc>()..add(RequestPermissionsEvent()),
      child: const StepsTrackerView(),
    );
  }
}

class StepsTrackerView extends StatelessWidget {
  const StepsTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Tracker'),
        backgroundColor: Colors.grey[300],
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          BlocBuilder<StepsTrackerBloc, StepsTrackerState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: () {
                  context.read<StepsTrackerBloc>().add(RefreshStepsDataEvent());
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<StepsTrackerBloc>().add(RefreshStepsDataEvent());
        },
        child: BlocConsumer<StepsTrackerBloc, StepsTrackerState>(
          listener: (context, state) {
            if (state is StepsTrackerHealthConnectError) {
              HealthConnectExceptionHandler.handleHealthOperation(
                operation: () => Future.error(
                  HealthConnectException(
                    type: state.errorType,
                    message: state.message,
                  ),
                ),
                context: context,
                showDialog: true,
              );
            }
          },
          builder: (context, state) {
            if (state is StepsTrackerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StepsTrackerError) {
              return context.buildErrorState(state.message);
            }

            if (state is StepsTrackerHealthConnectError) {
              return context.buildHealthConnectErrorState(
                state.message,
                state.errorType,
              );
            }

            if (state is StepsTrackerPermissionDenied) {
              return context.buildPermissionDeniedState(state.message);
            }

            if (state is StepsTrackerLoaded) {
              final todaySteps = state.todaySteps?.steps ?? 0;
              final weeklySteps = state.weeklySteps ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: StepsProgressBar(
                        currentSteps: todaySteps,
                        goalSteps: AppConstants.defaultDailyStepGoal,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (weeklySteps.isNotEmpty)
                      WeeklyStepsList(weeklySteps: weeklySteps),
                  ],
                ),
              );
            }

            return const Center(child: Text('Welcome to Steps Tracker'));
          },
        ),
      ),
    );
  }
}
