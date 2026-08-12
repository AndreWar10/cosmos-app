import 'package:flutter/material.dart';
import 'core/app.dart';
import 'core/setup/app_setup.dart';

void main() async {
  await AppSetup.initialize();
  runApp(const CosmosApp());
}
