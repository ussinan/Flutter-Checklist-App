import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'data/services/mock_data_service.dart';
import 'domain/repositories/task_repository.dart';
import 'presentation/pages/task_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await serviceLocator.allReady();
  
  final mockDataService = MockDataService(
    repository: serviceLocator<TaskRepository>(),
  );
  await mockDataService.initializeMockDataIfNeeded();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checklist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskListPage(),
    );
  }
}

