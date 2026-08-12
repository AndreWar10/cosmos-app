import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmos_app/core/locale/locale_cubit.dart';
import 'package:cosmos_app/core/locale/locale_provider.dart';
import 'package:cosmos_app/core/theme/app_theme.dart';
import 'package:cosmos_app/core/theme/theme_cubit.dart';
import 'package:cosmos_app/i18n/generated/app_localizations.dart';

import 'mock_app_cache.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    ThemeCubit? themeCubit,
    LocaleCubit? localeCubit,
    List<BlocProvider>? additionalProviders,
  }) async {
    final cache = MockAppCache();
    final providers = <BlocProvider>[
      BlocProvider<ThemeCubit>(
        create: (_) => themeCubit ?? ThemeCubit(cache),
      ),
      BlocProvider<LocaleCubit>(
        create: (_) =>
            localeCubit ?? LocaleCubit(LocaleProvider(), cache),
      ),
      ...?additionalProviders,
    ];

    await pumpWidget(
      MultiBlocProvider(
        providers: providers,
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          locale: const Locale('pt'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: widget,
        ),
      ),
    );

    await pumpAndSettle();
  }
}
