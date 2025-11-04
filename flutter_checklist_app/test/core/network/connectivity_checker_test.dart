import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_checklist_app/core/network/connectivity_checker.dart';

@GenerateMocks([Connectivity])
void main() {
  group('ConnectivityChecker Tests', () {
    late MockConnectivity mockConnectivity;
    late ConnectivityChecker connectivityChecker;

    setUp(() {
      mockConnectivity = MockConnectivity();
      connectivityChecker = ConnectivityChecker(connectivity: mockConnectivity);
    });

    test('hasInternetConnection - returns true when WiFi connected', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Act
      final result = await connectivityChecker.hasInternetConnection();

      // Assert
      expect(result, true);
    });

    test('hasInternetConnection - returns true when mobile data connected', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);

      // Act
      final result = await connectivityChecker.hasInternetConnection();

      // Assert
      expect(result, true);
    });

    test('hasInternetConnection - returns false when no connection', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      final result = await connectivityChecker.hasInternetConnection();

      // Assert
      expect(result, false);
    });

    test('hasInternetConnection - returns false on error', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenThrow(Exception('Connectivity check failed'));

      // Act
      final result = await connectivityChecker.hasInternetConnection();

      // Assert
      expect(result, false);
    });

    test('getConnectivityStatus - returns current status', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Act
      final status = await connectivityChecker.getConnectivityStatus();

      // Assert
      expect(status, ConnectivityResult.wifi);
    });

    test('getConnectivityStatus - returns none on error', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity())
          .thenThrow(Exception('Error'));

      // Act
      final status = await connectivityChecker.getConnectivityStatus();

      // Assert
      expect(status, ConnectivityResult.none);
    });
  });
}

