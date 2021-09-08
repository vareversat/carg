import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService({required this.flutterSecureStorage});

  final FlutterSecureStorage flutterSecureStorage;

  static const String storageUserEmailKey = 'userEmailAddress';

  Future<void> setEmail(String email) async {
    await flutterSecureStorage.write(key: storageUserEmailKey, value: email);
  }

  Future<void> clearEmail() async {
    await flutterSecureStorage.delete(key: storageUserEmailKey);
  }

  Future<String?> getEmail() async {
    return await flutterSecureStorage.read(key: storageUserEmailKey);
  }
}