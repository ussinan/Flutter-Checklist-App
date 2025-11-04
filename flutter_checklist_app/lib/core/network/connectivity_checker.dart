import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks device internet connectivity status.
class ConnectivityChecker {
  ConnectivityChecker({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Returns true if device has an active internet connection.
  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Returns the current connectivity type (wifi, mobile, or none).
  Future<ConnectivityResult> getConnectivityStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.firstWhere(
        (result) => result != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Stream that emits connectivity changes.
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.firstWhere(
        (result) => result != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    });
  }
}

