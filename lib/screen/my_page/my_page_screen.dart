import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:last_nyam_owner/component/MannerTemperatureBar.dart';
import 'package:last_nyam_owner/const/colors.dart';
import 'package:last_nyam_owner/screen/my_page/recipe_manage_screen.dart';
import 'package:last_nyam_owner/screen/my_page/review_list_screen.dart';
import 'package:last_nyam_owner/screen/my_page/store_manage_screen.dart';
import 'package:provider/provider.dart';
import 'package:last_nyam_owner/component/provider/user_state.dart';
import 'package:last_nyam_owner/screen/my_page/login_screen.dart';
import 'package:last_nyam_owner/screen/my_page/profile_edit_screen.dart';
import 'dart:typed_data';
import 'dart:convert';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _storage = const FlutterSecureStorage(); // Secure Storage instance
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColors['white'],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: defaultColors['black']),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            // 프로필 이미지와 사용자 정보
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: defaultColors['white'],
                  backgroundImage: userState.profileImage != null
                      ? MemoryImage(userState.profileImage!) // 선택된 이미지
                      : AssetImage('assets/image/profile_image.png')
                          as ImageProvider, // 기본 이미지 프로필 이미지 경로
                ),
                SizedBox(width: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !userState.isLogin ? '' : '냠냠이, ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!userState.isLogin) {
                          // AccessToken이 없는 경우 로그인 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                              // builder: (context) => ProfileEditScreen(),
                            ),
                          );
                        } else {
                          // AccessToken이 있는 경우 프로필 편집 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            !userState.isLogin
                                ? '로그인하고 냠냠 시작하기' // 로그인 메시지
                                : '${userState.userName}', // 사용자 이름 표시
                            style: TextStyle(
                              fontSize: 16,
                              color: defaultColors['green'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: defaultColors['lightGreen'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // 알림 텍스트
            MannerTemperatureBar(initialValue: userState.mannerTemperature),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),
            // 메뉴 리스트
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  '냠냠 목록',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: defaultColors['lightGreen'],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.store_outlined,
                        color: defaultColors['black']),
                    title: Text('가게 관리'),
                    trailing: Icon(Icons.chevron_right,
                        color: defaultColors['lightGreen']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreManageScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cookie_outlined,
                        color: defaultColors['black']),
                    title: Text('레시피 관리'),
                    trailing: Icon(Icons.chevron_right,
                        color: defaultColors['lightGreen']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeManageScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(FluentIcons.temperature_24_filled,
                        color: defaultColors['black']),
                    title: Text('받은 냠냠 평가'),
                    trailing: Icon(Icons.chevron_right,
                        color: defaultColors['lightGreen']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewListScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  if (userState.isLogin)
                    ListTile(
                      leading:
                          Icon(Icons.logout, color: defaultColors['black']),
                      title: Text('로그아웃'),
                      trailing: Icon(Icons.chevron_right,
                          color: defaultColors['lightGreen']),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  if (userState.isLogin)
                    ListTile(
                      leading: Icon(Icons.person_remove_outlined,
                          color: defaultColors['black']),
                      title: Text('탈퇴'),
                      trailing: Icon(Icons.chevron_right,
                          color: defaultColors['lightGreen']),
                      onTap: () => _showWithdrawalDialog(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down_sharp,
                    size: 36.0, color: defaultColors['black']),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                '로그아웃하면 \'라스트 냠\'의 기능을 이용하지 못합니다.\n정말 로그아웃하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 알림창 닫기
                  print('로그아웃 처리');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColors['green'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('로그아웃',
                    style: TextStyle(
                        fontSize: 16,
                        color: defaultColors['white'],
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawalDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down_sharp,
                    size: 36.0, color: defaultColors['black']),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                '탈퇴하면 \‘라스트 냠\’의 기능을 이용하지 못함과 동시에 사용 기록이 소멸됩니다.\n정말 탈퇴하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 알림창 닫기
                  print('탈퇴 처리');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColors['green'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('탈퇴',
                    style: TextStyle(
                        fontSize: 16,
                        color: defaultColors['white'],
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}