import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

class SecureStorage {
  static const String _boxName = 'secure_storage';
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  Box? _box;

  Future<Box> get box async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
    return _box!;
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    final b = await box;
    await b.put(_tokenKey, accessToken);
    await b.put(_refreshTokenKey, refreshToken);
  }

  String? getToken() {
    try {
      return _box?.get(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getTokenAsync() async {
    final b = await box;
    return b.get(_tokenKey);
  }

  Future<String?> getRefreshToken() async {
    final b = await box;
    return b.get(_refreshTokenKey);
  }

  Future<void> setUserInfo(int userId, String email) async {
    final b = await box;
    await b.put(_userIdKey, userId.toString());
    await b.put(_userEmailKey, email);
  }

  Future<int?> getUserId() async {
    final b = await box;
    final id = b.get(_userIdKey);
    return id != null ? int.tryParse(id.toString()) : null;
  }

  Future<String?> getUserEmail() async {
    final b = await box;
    return b.get(_userEmailKey);
  }

  Future<void> removeTokens() async {
    final b = await box;
    await b.delete(_tokenKey);
    await b.delete(_refreshTokenKey);
  }

  Future<void> removeUserInfo() async {
    final b = await box;
    await b.delete(_userIdKey);
    await b.delete(_userEmailKey);
  }

  Future<void> clearAll() async {
    final b = await box;
    await b.clear();
  }

  Future<bool> hasToken() async {
    final b = await box;
    final token = b.get(_tokenKey);
    return token != null && token.toString().isNotEmpty;
  }
}
