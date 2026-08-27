import 'shared_preferences.dart';

class PermissionManager {
  static List<String> _permissions = [];

  static Future<void> loadPermissions() async {
    _permissions = await getSavedPermissions();
  }

  static bool hasPermission(String permission) {
    return _permissions.contains(
      permission.trim().toLowerCase(),
    );
  }

  static void clearPermissions() {
    _permissions.clear();
  }
}