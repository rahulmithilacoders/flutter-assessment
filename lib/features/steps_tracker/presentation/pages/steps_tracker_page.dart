import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/steps_tracker_bloc.dart';
import '../bloc/steps_tracker_event.dart';
import '../bloc/steps_tracker_state.dart';
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
        child: BlocBuilder<StepsTrackerBloc, StepsTrackerState>(
          builder: (context, state) {
            if (state is StepsTrackerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is StepsTrackerError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StepsTrackerBloc>().add(LoadStepsDataEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is StepsTrackerPermissionDenied) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, size: 64, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Note: On Android, you may need to install Google Fit or Samsung Health for step tracking to work properly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<StepsTrackerBloc>().add(RequestPermissionsEvent());
                        },
                        child: const Text('Grant Permissions'),
                      ),
                    ],
                  ),
                ),
              );
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
            
            return const Center(
              child: Text('Welcome to Steps Tracker'),
            );
          },
        ),
      ),
    );
  }
}