import 'package:flutter/material.dart';
import 'package:nhs_pedometer/constants/shared_pref_key.dart';
import 'package:nhs_pedometer/ui/history/history_page.dart';
import 'package:nhs_pedometer/ui/main/main_page.dart';
import 'package:nhs_pedometer/ui/ranking/ranking_page.dart';
import 'package:nhs_pedometer/ui/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerStateManager with ChangeNotifier {
  int _currentIndex = 0;
  String imageUrl, accountName, accountEmail;

  DrawerStateManager() {
    SharedPreferences.getInstance().then((value) {
      imageUrl = value.getString(SharedPrefKey.imageUrl);
      accountName = value.getString(SharedPrefKey.name);
      accountEmail = value.getString(SharedPrefKey.email);
      notifyListeners();
    });
  }

  int get getCurrentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ignore: missing_return
  Widget get currentPage {
    switch(_currentIndex) {
      case 0: return MainPage();
      case 1: return HistoryPage();
      case 2: return RankingPage();
      case 3: return SettingsPage();
    }
  }
}