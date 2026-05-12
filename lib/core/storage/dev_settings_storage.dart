import 'package:shared_preferences/shared_preferences.dart';

class DevSettingsStorage {
  static const _keyEnabled = 'dev_mode_enabled';
  static const _keyFloatingDevTools = 'dev_floating_tools';
  static const _keyUseChucker = 'dev_use_chucker';
  static const _keyShowDebugInfo = 'dev_show_debug_info';
  static const _keyShowDebugButtons = 'dev_show_debug_buttons';
  static const _keyApiEnvironment = 'dev_api_environment';
  static const _keyShowChuckerNotification = 'dev_show_chucker_notification';
  static const _keyShowChuckerOnRelease = 'dev_show_chucker_on_release';
  static const _keyLanguage = 'dev_language';
  static const _keyGetCorpsPangkat = 'dev_get_corps_pangkat';
  static const _keyMockAiFeatures = 'dev_mock_ai_features';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnabled) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<String> getString(String key, {String defaultValue = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Helper keys
  static String get floatingDevToolsKey => _keyFloatingDevTools;
  static String get useChuckerKey => _keyUseChucker;
  static String get showDebugInfoKey => _keyShowDebugInfo;
  static String get showDebugButtonsKey => _keyShowDebugButtons;
  static String get apiEnvironmentKey => _keyApiEnvironment;
  static String get showChuckerNotificationKey => _keyShowChuckerNotification;
  static String get showChuckerOnReleaseKey => _keyShowChuckerOnRelease;
  static String get languageKey => _keyLanguage;
  static String get getCorpsPangkatKey => _keyGetCorpsPangkat;
  static String get mockAiFeaturesKey => _keyMockAiFeatures;
}
