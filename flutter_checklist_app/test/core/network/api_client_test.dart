import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_checklist_app/core/network/api_client.dart';
import 'package:flutter_checklist_app/core/network/connectivity_checker.dart';

@GenerateMocks([Connectivity])
void main() {
  group('ApiClient Tests', () {
    late Dio dio;
    late ApiClient apiClient;
    late MockConnectivity mockConnectivity;
    late ConnectivityChecker connectivityChecker;

    setUp(() {
      dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.com',
        ),
      );
      mockConnectivity = MockConnectivity();
      connectivityChecker = ConnectivityChecker(connectivity: mockConnectivity);
      apiClient = ApiClient(
        dio: dio,
        connectivityChecker: connectivityChecker,
      );
    });

    test('GET request - no internet connection throws NetworkException', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act & Assert
      expect(
        () => apiClient.get('/api/tasks'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('POST request - no internet connection throws NetworkException', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act & Assert
      expect(
        () => apiClient.post('/api/tasks', data: {}),
        throwsA(isA<NetworkException>()),
      );
    });

    test('NetworkException has status code property', () {
      // Arrange & Act
      final exception = NetworkException(
        'Test error',
        statusCode: 400,
      );

      // Assert
      expect(exception.statusCode, 400);
      expect(exception.isBadRequest, true);
      expect(exception.isUnauthorized, false);
    });

    test('NetworkException detects unauthorized errors', () {
      // Arrange & Act
      final exception = NetworkException(
        'Unauthorized',
        statusCode: 401,
      );

      // Assert
      expect(exception.isUnauthorized, true);
      expect(exception.isBadRequest, false);
    });

    test('NetworkException detects server errors', () {
      // Arrange & Act
      final exception = NetworkException(
        'Server error',
        statusCode: 500,
      );

      // Assert
      expect(exception.isServerError, true);
      expect(exception.statusCode, 500);
    });
  });
}

