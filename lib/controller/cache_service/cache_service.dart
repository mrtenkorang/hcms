import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hcms_revived2/screens/addedMaps/dependencies/globals.dart';
import 'package:hcms_revived2/screens/home/auth/usersingin/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class CacheService {
  static const String _loginStatusKey = 'isLoggedIn';
  static const String _userInfoKey = 'user_info';

  final SharedPreferences _prefs;

  // Private constructor
  CacheService._(this._prefs);

  // Factory constructor to handle async initialization
  static Future<CacheService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheService._(prefs);
  }

  /// Saves the login status to shared preferences
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    try {
      await _prefs.setBool(_loginStatusKey, isLoggedIn);
    } catch (e) {
      debugPrint('Error saving login status: $e');
      rethrow;
    }
  }

  /// Retrieves the login status from shared preferences
  bool? getLoginStatus() {
    try {
      return _prefs.getBool(_loginStatusKey);
    } catch (e) {
      debugPrint('Error getting login status: $e');
      return null;
    }
  }

  /// Saves UserModel information to shared preferences
  Future<void> saveUserInfo(UserModel userInfo) async {
    try {
      final userJson = userInfo.toJson();
      await _prefs.setString(_userInfoKey, jsonEncode(userJson));
    } catch (e) {
      debugPrint('Error saving UserModel info: $e');
      rethrow;
    }
  }

  /// Retrieves UserModel information from shared preferences
  Future<UserModel?> getUserInfo() async {
    try {
      final userInfo = _prefs.getString(_userInfoKey);
      if (userInfo != null) {
        final userMap = jsonDecode(userInfo) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting UserModel info: $e');
      return null;
    }
  }

  /// Clears all UserModel data (logout)
  Future<void> clearUserData() async {
    try {
      await _prefs.remove(_userInfoKey);
      await _prefs.remove(_loginStatusKey);
    } catch (e) {
      debugPrint('Error clearing UserModel data: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> logout(BuildContext context) async {
    try {
      await clearUserData();
      await saveLoginStatus(false);

      Globals().showSnackBar(
        title: "Logged Out",
        message: "Logged out successfully",
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserSignIn()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error logging out: $e');
      rethrow;
    }
  }
}
