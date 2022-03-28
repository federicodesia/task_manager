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

  Future<String> _read({required String key}) async{
    try{
      return await _secureStorage.read(key: key) ?? "";
    }
    catch(_) {
      return "";
    }
  }

  Future<String> get refreshToken => _read(key: "refreshToken");
  Future<String> get accessToken => _read(key: "accessToken");
  Future<String> get passwordToken => _read(key: "passwordToken");

  Future<AuthCredentials> get authCredentials async {
    return AuthCredentials(
      refreshToken: await refreshToken,
      accessToken: await accessToken,
      passwordToken: await passwordToken
    );
  }

  Future<String> get firebaseMessagingToken => _read(key: "firebaseMessagingToken");
}

class _WriteSecureStorage {
  final FlutterSecureStorage _secureStorage;
  _WriteSecureStorage(this._secureStorage);

  Future<void> _write({
    required String key,
    required String value
  }) async{
    try{
      await _secureStorage.write(key: key, value: value);
    }
    catch(_) {}
  }

  Future<void> refreshToken(String value) => _write(key: "refreshToken", value: value);
  Future<void> accessToken(String value) => _write(key: "accessToken", value: value);
  Future<void> passwordToken(String value) => _write(key: "passwordToken", value: value);

  Future<void> authCredentials(AuthCredentials credentials) async {
    await refreshToken(credentials.refreshToken);
    await accessToken(credentials.accessToken);
    await passwordToken(credentials.passwordToken);
  }

  Future<void> firebaseMessagingToken(String value) => _write(key: "firebaseMessagingToken", value: value);
}

class _DeleteSecureStorage {
  final FlutterSecureStorage _secureStorage;
  _DeleteSecureStorage(this._secureStorage);

  Future<void> _delete({required String key}) async{
    try{
      await _secureStorage.delete(key: key);
    }
    catch(_) {}
  }
  
  Future<void> all() async{
    try{
      await _secureStorage.deleteAll();
    }
    catch(_) {}
  }

  Future<void> refreshToken() => _delete(key: "refreshToken");
  Future<void> accessToken() => _delete(key: "accessToken");
  Future<void> passwordToken() => _delete(key: "passwordToken");
  Future<void> firebaseMessagingToken() => _delete(key: "firebaseMessagingToken");
}