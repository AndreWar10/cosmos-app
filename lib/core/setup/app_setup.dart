import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../di/injection_container.dart';
import '../env/app_env.dart';

abstract class AppSetup {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await AppEnvImpl.load();
    await setupDependencies();
  }
}
