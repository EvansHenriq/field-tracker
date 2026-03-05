import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyName = 'technician_name';
  static const _keyId = 'technician_id';
  static const _keyLocale = 'locale';

  static Future<String?> getTechnicianName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getTechnicianId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyId);
  }

  static Future<void> saveTechnicianProfile({
    required String name,
    required String id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyId, id);
  }

  static Future<bool> hasProfile() async {
    final name = await getTechnicianName();
    final id = await getTechnicianId();
    return name != null && name.isNotEmpty && id != null && id.isNotEmpty;
  }

  static Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLocale) ?? 'pt';
  }

  static Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, locale);
  }
}
