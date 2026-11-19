import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  
  late final GetStorage _box;
  
  static const _keyToken = 'token';
  static const _keyUser = 'user_data';
  static const _keyIsDarkMode = 'is_dark_mode';
  
  Future<StorageService> init() async {
    _box = GetStorage();
    return this;
  }
  
  bool getIsDarkMode() => _box.read<bool>(_keyIsDarkMode) ?? false;
  
  Future<void> saveIsDarkMode(bool isDark) => _box.write(_keyIsDarkMode, isDark);
  
  String? getToken() => _box.read<String>(_keyToken);
  
  Future<void> saveToken(String token) => _box.write(_keyToken, token);
  
  Future<void> clearToken() => _box.remove(_keyToken);
  
  bool isLoggedIn() => getToken() != null;
  
  Map<String, dynamic>? getUserData() {
    final raw = _box.read(_keyUser);
    if (raw == null) return null;
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }
  
  Future<void> saveUserData(Map<String, dynamic> data) => _box.write(_keyUser, data);
  
  Future<void> clearAll() async {
    await _box.erase();
  }
}
