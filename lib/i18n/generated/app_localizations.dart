import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Cosmos'**
  String get appTitle;

  /// Bottom nav: Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav: News tab
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get navNews;

  /// Bottom nav: Launches tab
  ///
  /// In en, this message translates to:
  /// **'Launches'**
  String get navLaunches;

  /// Bottom nav: Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Home page app bar title
  ///
  /// In en, this message translates to:
  /// **'Cosmos'**
  String get homeTitle;

  /// News page app bar title
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newsTitle;

  /// News search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search news...'**
  String get newsSearchHint;

  /// News empty state message
  ///
  /// In en, this message translates to:
  /// **'No news found'**
  String get newsEmpty;

  /// News generic error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load news'**
  String get newsErrorGeneric;

  /// News error retry button
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get newsErrorRetry;

  /// Launches page app bar title
  ///
  /// In en, this message translates to:
  /// **'Launches'**
  String get launchesTitle;

  /// Launches filter: upcoming
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get launchesUpcoming;

  /// Launches filter: past
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get launchesPast;

  /// Launches filter: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get launchesAll;

  /// Launches status filter: success
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get launchesFilterSuccess;

  /// Launches status filter: failure
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get launchesFilterFailed;

  /// Launches empty state
  ///
  /// In en, this message translates to:
  /// **'No launches found'**
  String get launchesEmpty;

  /// Launches error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load launches'**
  String get launchesErrorGeneric;

  /// Launches retry button
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get launchesErrorRetry;

  /// Launch detail: rocket label
  ///
  /// In en, this message translates to:
  /// **'Rocket'**
  String get launchDetailRocket;

  /// Launch detail: launchpad label
  ///
  /// In en, this message translates to:
  /// **'Launchpad'**
  String get launchDetailLaunchpad;

  /// Launch detail: date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get launchDetailDate;

  /// Launch detail: status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get launchDetailStatus;

  /// Launch status: success
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get launchDetailStatusSuccess;

  /// Launch status: failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get launchDetailStatusFailed;

  /// Launch status: upcoming
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get launchDetailStatusUpcoming;

  /// Launch detail: webcast button
  ///
  /// In en, this message translates to:
  /// **'Watch Webcast'**
  String get launchDetailWatchWebcast;

  /// Launch detail: no description
  ///
  /// In en, this message translates to:
  /// **'No details available'**
  String get launchDetailNoDetails;

  /// Settings page app bar title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section: appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Settings: dark theme toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get settingsDarkTheme;

  /// Settings: theme toggle on
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get settingsThemeEnabled;

  /// Settings: theme toggle off
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsThemeDisabled;

  /// Settings section: language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Settings: language selector label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// Settings: Portuguese option
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get settingsLanguagePortuguese;

  /// Settings: English option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
