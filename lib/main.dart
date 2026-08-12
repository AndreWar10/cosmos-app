import 'package:flutter/material.dart';

import 'core/app.dart';
import 'core/di/injection_container.dart';
import 'core/env/app_env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnvImpl.load();
  await setupDependencies();
  runApp(const CosmosApp());
}
