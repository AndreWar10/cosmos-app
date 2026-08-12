class LocaleProvider {
  String _languageCode = 'pt';

  String get languageCode => _languageCode;

  bool get isPortuguese => _languageCode == 'pt';

  void setLanguageCode(String code) => _languageCode = code;
}
