import 'package:dio/dio.dart';

import '../locale/locale_provider.dart';

class LocaleInterceptor extends Interceptor {
  const LocaleInterceptor(this._localeProvider);

  final LocaleProvider _localeProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_localeProvider.isPortuguese && options.path.startsWith('/api/')) {
      options.path = options.path.replaceFirst('/api/', '/api/pt/');
    }
    handler.next(options);
  }
}
