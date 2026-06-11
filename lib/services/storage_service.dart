import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Use 'const' for the storage instance for performance optimization
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _workerUrlKey = 'CLOUDFLARE_WORKER_URL';
  static const String _authTokenKey = 'OPS_NODE_AUTH_TOKEN';

  /// Save your Cloudflare Worker endpoint securely to the device Keystore
  Future<void> saveWorkerUrl(String url) async {
    try {
      await _storage.write(key: _workerUrlKey, value: url);
    } catch (e) {
      debugPrint("StorageService: Error saving URL - $e");
    }
  }

  /// Read the Cloudflare Worker endpoint from storage
  Future<String?> getWorkerUrl() async {
    try {
      return await _storage.read(key: _workerUrlKey);
    } catch (e) {
      debugPrint("StorageService: Error reading URL - $e");
      return null;
    }
  }

  /// Save an optional authentication token for secure cluster handshakes
  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
    } catch (e) {
      debugPrint("StorageService: Error saving Token - $e");
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _authTokenKey);
    } catch (e) {
      debugPrint("StorageService: Error reading Token - $e");
      return null;
    }
  }

  /// Clean wipe of secure storage if resetting the system node
  Future<void> clearConfigs() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint("StorageService: Error clearing configs - $e");
    }
  }
}