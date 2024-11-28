import 'dart:io';
import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String password = 'testest';
  String phoneNumber = '010-1111-1111';
  String userName = '컴공피주먹';
  File? profileImage = null;
  int orderCount = 0;

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

  void updateProfileImage(File? newImage) {
    profileImage = newImage;
    notifyListeners();
  }

  void updateOrderCount(int newCount) {
    orderCount = newCount;
    notifyListeners();
  }
}
