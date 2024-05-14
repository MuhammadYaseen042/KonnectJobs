import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firbase_Services/modelClasses/user.dart';

final userDataProvider = StateNotifierProvider((ref) => UserData(null));

class UserData extends StateNotifier<UserModelClass?> {
  UserData(UserModelClass? userModelClass) : super(userModelClass);

  void addUserData(UserModelClass userModelClass) {
    state = userModelClass; // Replace the entire state with the new user
  }
}






class LanguageController with ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  LanguageController() {
    _loadLanguagePreference();
  }

  void _loadLanguagePreference() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? languageCode = sp.getString("Language_code");
    if (languageCode != null) {
      _appLocale = Locale(languageCode);
    } else {
      _appLocale = Locale('en'); // Default to English if no language preference is set
    }
    notifyListeners();
  }

  void changeLang(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (type == Locale('en')) {
      await sp.setString("Language_code", "en");
    } else {
      await sp.setString("Language_code", "ur");
    }
    _appLocale = type;
    notifyListeners();
  }
}