class LocaleProvider {
  LocaleProvider([String initialCode = 'pt'])
      : _languageCode = initialCode;

  String _languageCode;

  String get languageCode => _languageCode;

  bool get isPortuguese => _languageCode == 'pt';

  void setLanguageCode(String code) => _languageCode = code;
}
