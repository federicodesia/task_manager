import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/models/auth_credentials.dart';

class SecureStorageRepository{

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final _ReadSecureStorage read = _ReadSecureStorage(_secureStorage);  
  late final _WriteSecureStorage write = _WriteSecureStorage(_secureStorage);
  late final _DeleteSecureStorage delete = _DeleteSecureStorage(_secureStorage);
}

class _ReadSecureStorage {
  final FlutterSecureStorage _secureStorage;
  _ReadSecureStorage(this._secureStorage);

  Future<String> get refreshToken async => await _secureStorage.read(key: "refreshToken") ?? "";
  Future<String> get accessToken async => await _secureStorage.read(key: "accessToken") ?? "";
  Future<String> get passwordToken async => await _secureStorage.read(key: "passwordToken") ?? "";

  Future<AuthCredentials> get authCredentials async {
    return AuthCredentials(
      refreshToken: await refreshToken,
      accessToken: await accessToken,
      passwordToken: await passwordToken
    );
  }
}

class _WriteSecureStorage {
  final FlutterSecureStorage _secureStorage;
  _WriteSecureStorage(this._secureStorage);

  Future<void> refreshToken(String value) => _secureStorage.write(key: "refreshToken", value: value);
  Future<void> accessToken(String value) => _secureStorage.write(key: "accessToken", value: value);
  Future<void> passwordToken(String value) => _secureStorage.write(key: "passwordToken", value: value);

  Future<void> authCredentials(AuthCredentials credentials) async {
    await refreshToken(credentials.refreshToken);
    await accessToken(credentials.accessToken);
    await passwordToken(credentials.passwordToken);
  }
}

class _DeleteSecureStorage {
  final FlutterSecureStorage _secureStorage;
  _DeleteSecureStorage(this._secureStorage);

  Future<void> all() => _secureStorage.deleteAll();
  Future<void> refreshToken() => _secureStorage.delete(key: "refreshToken");
  Future<void> accessToken() => _secureStorage.delete(key: "accessToken");
  Future<void> passwordToken() => _secureStorage.delete(key: "passwordToken");
}