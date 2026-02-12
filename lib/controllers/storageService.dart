import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences prefs;

  Future<StorageService> init() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await prefs.setString('self', jsonEncode(user));
  }

  Map<String, dynamic>? get user {
    final data = prefs.getString('self');
    
    if (data == null) return null;
    return jsonDecode(data);
  }

  Future<void> setHasUserData(bool value) async {
    await prefs.setBool('hasUserData', value);
  }

  bool get hasUserData{
    return prefs.getBool("hasUserData") ?? false;
  }

Future<void> setWSconnected(bool value) async {
    await prefs.setBool('isWSconnected', value);
  }

  bool get isWSconnected{
    return prefs.getBool("isWSconnected") ?? false;
  }

  void clear() {
    prefs.clear();
  }
}
