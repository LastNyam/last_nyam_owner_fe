import 'package:flutter/material.dart';
import 'dart:typed_data';

class UserState with ChangeNotifier {
  String password = 'testest';
  String phoneNumber = '010-1234-5678';
  String userName = 'test';
  String storeName = 'test';
  Uint8List? profileImage = null;
  double mannerTemperature = 50;
  bool isLogin = true;

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
    mannerTemperature = 36.5;
    isLogin = false;
  }
}
