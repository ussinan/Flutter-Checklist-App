import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/network/api_client.dart';
import '../../core/network/connectivity_checker.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Configures dependency injection for the application.
Future<void> configureDependencies() async {
  await Hive.initFlutter();

  serviceLocator.registerLazySingletonAsync<Box<Map>>(
    () async => await Hive.openBox<Map>('tasks_box'),
  );

  serviceLocator.registerLazySingleton<ConnectivityChecker>(
    () => ConnectivityChecker(),
  );

  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(
      dio: serviceLocator<Dio>(),
      connectivityChecker: serviceLocator<ConnectivityChecker>(),
    ),
  );

  serviceLocator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(boxFuture: serviceLocator.getAsync<Box<Map>>),
  );

  const bool enableRemoteSync = true;
  
  if (enableRemoteSync) {
    serviceLocator.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(apiClient: serviceLocator<ApiClient>()),
    );
  }

  serviceLocator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      localDataSource: serviceLocator<TaskLocalDataSource>(),
      remoteDataSource: enableRemoteSync
          ? serviceLocator<TaskRemoteDataSource>()
          : null,
    ),
  );
}
