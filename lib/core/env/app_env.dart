import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppEnv {
  String get baseUrl;
}

class AppEnvImpl implements AppEnv {
  @override
  String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static Future<void> load() => dotenv.load(fileName: '.env');
}
