import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Accesses the native hardware-backed secure storage on Android
  final _storage = const FlutterSecureStorage();

  static const String _workerUrlKey = 'CLOUDFLARE_WORKER_URL';
  static const String _authTokenKey = 'OPS_NODE_AUTH_TOKEN';

  /// Save your Cloudflare Worker endpoint securely to the device Keystore
  Future<void> saveWorkerUrl(String url) async {
    await _storage.write(key: _workerUrlKey, value: url);
  }

  /// Read the Cloudflare Worker endpoint from storage
  Future<String?> getWorkerUrl() async {
    return await _storage.read(key: _workerUrlKey);
  }

  /// Save an optional authentication token for secure cluster handshakes
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  /// Clean wipe of secure storage if resetting the system node
  Future<void> clearConfigs() async {
    await _storage.deleteAll();
  }
}