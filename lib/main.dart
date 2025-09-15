import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'features/steps_tracker/presentation/pages/steps_tracker_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const StepsTrackerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}