import 'package:flutter/material.dart';
import 'dart:typed_data';

class UserState with ChangeNotifier {
  String phoneNumber = '';
  String userName = '';
  String storeName = '';
  Uint8List? profileImage = null;
  String callNumber = '';
  String address = '';
  double mannerTemperature = 0;
  bool isLogin = false;

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
  void updateCallNumber(String newCallNumber) {
    callNumber = newCallNumber;
    notifyListeners();
  }

  void updateAddress(String newAddress) {
    address = newAddress;
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
    phoneNumber = '';
    userName = '';
    storeName = '';
    profileImage = null;
    callNumber = '';
    address = '';
    mannerTemperature = 0;
    isLogin = false;
  }
}
