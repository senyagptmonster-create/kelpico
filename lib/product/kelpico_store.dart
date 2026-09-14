import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class KelpicoStore extends ChangeNotifier {
  SharedPreferences? _prefs;
  List<dynamic> _inventory = [];

  List<dynamic> get inventory => _inventory;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final data = _prefs?.getString('kelpico_data');
    if (data != null) {
      _inventory = jsonDecode(data);
    }
    notifyListeners();
  }

  void addItem(String item) {
    _inventory.add(item);
    _prefs?.setString('kelpico_data', jsonEncode(_inventory));
    notifyListeners();
  }
}
