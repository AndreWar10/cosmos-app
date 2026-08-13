import 'package:dio/dio.dart';

bool isConnectionError(Object error) {
  if (error is DioException) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown &&
            error.error.toString().contains('SocketException');
  }
  return false;
}
