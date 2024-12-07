import 'package:flutter/material.dart';
import 'dart:typed_data';

class UserState with ChangeNotifier {
  String password = '';
  String phoneNumber = '';
  String userName = '';
  String storeName = '';
  Uint8List? profileImage = null;
  double mannerTemperature = 0;
  bool isLogin = false;

  void updatePassword(String newPassword) {
    password = newPassword;
    notifyListeners();
  }

  void updatePhoneNumber(String newPhoneNumber) {
    phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }

  void updateStoreName(String newStoreName) {
    storeName = newStoreName;
    notifyListeners();
  }

  void updateProfileImage(Uint8List? newImage) {
    profileImage = newImage;
    notifyListeners();
  }

  void updateMannerTemperature(double newMannerTemperature) {
    mannerTemperature = newMannerTemperature;
    notifyListeners();
  }

  void updateIsLogin(bool newLogin) {
    isLogin = newLogin;
    notifyListeners();
  }

  void initState() {
    password = '';
    phoneNumber = '';
    userName = '';
    storeName = '';
    profileImage = null;
    mannerTemperature = 0;
    isLogin = false;
  }
}
