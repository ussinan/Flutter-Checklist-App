import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'connectivity_checker.dart';

/// HTTP client wrapper using Dio for making network requests.
/// Handles connectivity checks, error handling, and request/response logging.
class ApiClient {
  ApiClient({
    Dio? dio,
    String? baseUrl,
    ConnectivityChecker? connectivityChecker,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? 'https://api.example.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                sendTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ),
        _connectivityChecker = connectivityChecker ?? ConnectivityChecker() {
    _setupInterceptors();
  }

  final Dio _dio;
  final ConnectivityChecker _connectivityChecker;

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('REQUEST[${options.method}] => ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Performs a GET request to the specified path.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (!await _connectivityChecker.hasInternetConnection()) {
      throw NetworkException('No internet connection. Please check your network.');
    }

    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on NetworkException {
      rethrow;
    }
  }

  /// Performs a POST request to the specified path.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (!await _connectivityChecker.hasInternetConnection()) {
      throw NetworkException('No internet connection. Please check your network.');
    }

    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on NetworkException {
      rethrow;
    }
  }

  /// Performs a PUT request to the specified path.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (!await _connectivityChecker.hasInternetConnection()) {
      throw NetworkException('No internet connection. Please check your network.');
    }

    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on NetworkException {
      rethrow;
    }
  }

  /// Performs a DELETE request to the specified path.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (!await _connectivityChecker.hasInternetConnection()) {
      throw NetworkException('No internet connection. Please check your network.');
    }

    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on NetworkException {
      rethrow;
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        String? serverMessage;
        if (responseData is Map<String, dynamic>) {
          serverMessage = responseData['message'] as String? ?? 
                         responseData['error'] as String?;
        }
        
        switch (statusCode) {
          case 400:
            return NetworkException(
              serverMessage ?? 'Bad request. Please check your input and try again.',
              statusCode: 400,
            );
          case 401:
            return NetworkException(
              serverMessage ?? 'Unauthorized. Please login again.',
              statusCode: 401,
            );
          case 403:
            return NetworkException(
              serverMessage ?? 'Access forbidden. You don\'t have permission.',
              statusCode: 403,
            );
          case 404:
            return NetworkException(
              serverMessage ?? 'Resource not found.',
              statusCode: 404,
            );
          case 422:
            return NetworkException(
              serverMessage ?? 'Validation error. Please check your input.',
              statusCode: 422,
            );
          case 429:
            return NetworkException(
              serverMessage ?? 'Too many requests. Please try again later.',
              statusCode: 429,
            );
          default:
            if (statusCode != null && statusCode >= 500) {
              return NetworkException(
                serverMessage ?? 'Server error. Please try again later.',
                statusCode: statusCode,
              );
            }
            return NetworkException(
              serverMessage ?? 'Request failed with status code ${statusCode ?? 'unknown'}.',
              statusCode: statusCode,
            );
        }
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      case DioExceptionType.unknown:
        return NetworkException('No internet connection. Please check your network.');
      default:
        return NetworkException('An unexpected error occurred: ${error.message}');
    }
  }
}

/// Exception thrown when network requests fail.
class NetworkException implements Exception {
  NetworkException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  bool get isBadRequest => statusCode == 400;

  bool get isServerError => statusCode != null && statusCode! >= 500;

  @override
  String toString() => statusCode != null
      ? 'NetworkException[$statusCode]: $message'
      : 'NetworkException: $message';
}
