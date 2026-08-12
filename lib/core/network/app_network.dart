import 'package:dio/dio.dart';

import '../locale/locale_provider.dart';
import 'locale_interceptor.dart';

abstract class AppNetwork {
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}

class AppNetworkImpl implements AppNetwork {
  AppNetworkImpl({
    required String baseUrl,
    required LocaleProvider localeProvider,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 25),
            receiveTimeout: const Duration(seconds: 25),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(LocaleInterceptor(localeProvider));
    assert(() {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      return true;
    }());
  }

  final Dio _dio;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }
}
